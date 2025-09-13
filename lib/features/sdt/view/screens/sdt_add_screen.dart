// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdt/core/utils/extensions.dart';
import 'package:sdt/core/utils/date_math.dart';
import 'package:sdt/features/settings/view/providers/settings_provider.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdt/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdt/features/sdt/view/providers/sdt_provider.dart';
import 'package:sdt/features/sdt/view/providers/sdt_usecase_providers.dart';
import 'package:sdt/features/sdt/view/widgets/ds_background_image.dart';
import 'package:sdt/features/sdt/view/widgets/ds_content.dart';
import 'package:sdt/features/sdt/view/widgets/ds_settings_sheet.dart';
import 'package:sdt/features/images/domain/entities/fis_image.dart';
import 'package:sdt/features/images/view/providers/image_provider.dart';
import 'package:sdt/features/images/view/screens/image_search_screen.dart';
import 'package:sdt/l10n/app_localizations.dart';

class SdtAddScreen extends ConsumerStatefulWidget {
  final SdtEntry? entry;

  const SdtAddScreen({super.key, this.entry});

  static final String path = 'ds-add-screen';

  @override
  ConsumerState<SdtAddScreen> createState() => _SdtAddScreenState();
}

class _SdtAddScreenState extends ConsumerState<SdtAddScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  FisImage? _selectedImage;

  bool get _isEditing => widget.entry != null;

  bool _showUiElements = true;
  late SdtSettings _settings;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      final entry = widget.entry!;
      _settings = entry.settings ?? SdtSettings();
      _selectedDate = entry.date;
      _titleController.text = entry.title;
      if (entry.imageUrl != null) {
        _selectedImage = FisImage(
          url: entry.imageUrl!,
          preview: entry.imageUrl!,
        );
      }
    } else {
      _settings = SdtSettings();
      _loadRandomImage();
      // Use a post-frame callback to access context for localization.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _titleController.text = AppLocalizations.of(context)!.new_event,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadRandomImage() async {
    if (_isEditing) return; // Don't load a random image when editing

    // Ensure the provider is ready before reading.
    await ref.read(imageSearchProvider.future);
    final imageState = ref.read(imageSearchProvider).asData?.value;

    if (imageState != null && imageState.images.isNotEmpty) {
      setState(() {
        _selectedImage =
            imageState.images[Random().nextInt(imageState.images.length)];
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await _showDatePickerWithOffset(
      initialDate: _selectedDate,
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _pickImage() async {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Symbols.photo_camera),
              title: Text(loc.take_a_picture),
              onTap: () => context.pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Symbols.photo_library),
              title: Text(loc.choose_from_gallery),
              onTap: () => context.pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Symbols.travel_explore),
              title: Text(loc.search_online),
              onTap: () => context.pop(null), // Special case for online
            ),
          ],
        ),
      ),
    ).then((source) {
      if (source != null) {
        _getImageFromDevice(source);
      } else if (source == null && mounted) {
        // This indicates the 'Search online' option was tapped
        _searchOnlineImage();
      }
    });
  }

  Future<void> _searchOnlineImage() async {
    final imageUrl = await context.push<String>(
      MaterialPageRoute(builder: (context) => const ImageSearchScreen()),
    );

    if (imageUrl != null) {
      // We only get a URL back, so we create a temporary FisImage.
      setState(
        () => _selectedImage = FisImage(url: imageUrl, preview: imageUrl),
      );
    }
  }

  Future<void> _getImageFromDevice(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(
          () => _selectedImage = FisImage(
            url: pickedFile.path,
            preview: pickedFile.path,
          ),
        );
      }
    } on PlatformException catch (e) {
      // Handle user denying permission (camera/gallery) gracefully.
      String message;
      switch (e.code) {
        case 'camera_access_denied':
          message = 'Camera permission denied.';
          break;
        case 'photo_access_denied':
        case 'photo_library_access_denied':
          message = 'Photo library permission denied.';
          break;
        default:
          message = 'Failed to pick image (${e.code}).';
      }
      if (mounted) {
        context.showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty) {
      context.showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_enter_a_title),
        ),
      );
      return;
    }

    try {
      if (_isEditing) {
        final updatedEntry = widget.entry!.copyWith(
          title: _titleController.text,
          date: _selectedDate,
          imageUrl: _selectedImage?.url,
          settings: _settings,
        );
        // Use case + explicit invalidation
        await ref.read(updateEntryProvider).call(updatedEntry);
      } else {
        final newEntry = SdtEntry(
          title: _titleController.text,
          date: _selectedDate,
          imageUrl: _selectedImage?.url,
          settings: _settings,
        );
        await ref.read(addEntryProvider).call(newEntry);
      }

      // Refresh lists explicitly so Home / Ds / Dt update
      ref.invalidate(dsNotifierProvider);
      ref.invalidate(dtNotifierProvider);

      if (!mounted) return;
      if (_isEditing) {
        context.pop();
      }
      context.pop();
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showSettingsPanel() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => SdtSettingsSheet(
          settings: _settings,
          onSettingsChanged: (newSettings) =>
              setState(() => _settings = newSettings),
          scrollController: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // The AppBar is now part of the body stack to allow it to be toggled.
      body: GestureDetector(
        onTap: () {
          // Hide keyboard and lose focus from any text field.
          FocusScope.of(context).unfocus();

          final newShowUiState = !_showUiElements;
          // Toggle UI visibility
          setState(() => _showUiElements = newShowUiState);

          // Toggle immersive mode for a true preview
          if (newShowUiState) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            SdtBackgroundImage(imageUrl: _selectedImage?.url),

            // Overlay
            Container(
              color: _settings.overlayColor.withAlpha(
                (_settings.overlayAlpha * 255).round(),
              ),
            ),

            // UI Elements (AppBar and Content)
            AnimatedOpacity(
              opacity: _showUiElements ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              // Ignore pointer when hidden so it doesn't block taps to show UI again.
              child: IgnorePointer(
                ignoring: !_showUiElements,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      actions: [
                        IconButton(
                          icon: const Icon(Symbols.image),
                          tooltip: loc.image_optional,
                          onPressed: _pickImage,
                        ),
                        IconButton(
                          icon: const Icon(Symbols.tune),
                          tooltip: loc.customize,
                          onPressed: _showSettingsPanel,
                        ),
                        IconButton(
                          icon: const Icon(Symbols.calendar_month),
                          tooltip: loc.date,
                          onPressed: _pickDate,
                        ),
                        TextButton(
                          onPressed: _saveEntry,
                          child: Text(
                            _isEditing ? loc.save_changes : loc.save,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            SdtContent(
              entry: SdtEntry(
                title: _titleController.text,
                date: _selectedDate,
              ),
              settings: _settings,
              contentContext: SdtContentContext.editor,
              titleController: _titleController,
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDatePickerWithOffset({required DateTime initialDate}) {
    final app = ref.watch(settingsNotifierProvider);
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _DatePickerWithOffsetSheet(
        initialDate: initialDate,
        countToday: app.countToday,
        countLastDay: app.countLastDay,
      ),
    );
  }
}

// Add this private widget at the end of the file (below the SdtAddScreen state class)
class _DatePickerWithOffsetSheet extends StatefulWidget {
  final DateTime initialDate;
  final bool countToday;
  final bool countLastDay;
  const _DatePickerWithOffsetSheet({
    required this.initialDate,
    required this.countToday,
    required this.countLastDay,
  });

  @override
  State<_DatePickerWithOffsetSheet> createState() =>
      _DatePickerWithOffsetSheetState();
}

class _DatePickerWithOffsetSheetState
    extends State<_DatePickerWithOffsetSheet> {
  late DateTime tempSelected;
  late TextEditingController offsetCtrl;
  final FocusNode _offsetFocus = FocusNode();

  // -1 = past, 0 = calendar only (default), 1 = future
  int offsetDirection = 0;
  bool hasClearedOffsetField = false;

  late Key calendarKey;

  @override
  void initState() {
    super.initState();
    tempSelected = widget.initialDate;
    offsetCtrl = TextEditingController(text: '0');
    calendarKey = ValueKey(tempSelected.toIso8601String());
  }

  @override
  void dispose() {
    offsetCtrl.dispose();
    _offsetFocus.dispose();
    super.dispose();
  }

  int parseOffset() => int.tryParse(offsetCtrl.text) ?? 0;

  void _applyOffset() {
    if (offsetDirection == 0) return;
    final off = parseOffset().abs();
    final target = SdtDateMath.addDaysFromToday(
      off,
      future: offsetDirection > 0,
      includeToday: widget.countToday,
      includeLastDay: widget.countLastDay,
    );
    setState(() {
      tempSelected = target;
      calendarKey = ValueKey(tempSelected.toIso8601String());
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final materialLoc = MaterialLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header actions
              Row(
                children: [
                  Text(loc.date, style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Symbols.today),
                    label: Text(loc.today),
                    onPressed: () => setState(() {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      tempSelected = today;
                      calendarKey = ValueKey(tempSelected.toIso8601String());
                    }),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(materialLoc.cancelButtonLabel),
                  ),
                  FilledButton(
                    onPressed: () {
                      final off = parseOffset().abs();
                      // If no offset or "calendar only", return the picked calendar date
                      if (offsetDirection == 0 || off == 0) {
                        Navigator.pop(context, tempSelected);
                      } else {
                        final d = SdtDateMath.addDaysFromToday(
                          off,
                          future: offsetDirection > 0,
                          includeToday: widget.countToday,
                          includeLastDay: widget.countLastDay,
                        );
                        Navigator.pop(context, d);
                      }
                    },
                    child: Text(materialLoc.okButtonLabel),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Calendar picker
              CalendarDatePicker(
                key: calendarKey,
                initialDate: tempSelected,
                firstDate: DateTime(1900),
                lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                onDateChanged: (d) => setState(() => tempSelected = d),
              ),

              // Quick offset
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  loc.quick_offset_from_today,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _offsetFocus,
                      controller: offsetCtrl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: loc.offset_in_days,
                        hintText: '${loc.e_g} 10',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        // Clear only once and only if current value is 0
                        if (!hasClearedOffsetField &&
                            (offsetCtrl.text.trim().isEmpty ||
                                offsetCtrl.text.trim() == '0')) {
                          offsetCtrl.clear();
                          hasClearedOffsetField = true;
                        }
                      },
                      onChanged: (_) => _applyOffset(),
                      onSubmitted: (_) {
                        // Keep the value and just dismiss the keyboard if desired
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      IconButton(
                        tooltip: 'Increment',
                        onPressed: () {
                          final v = parseOffset().abs() + 1;
                          offsetCtrl.text = '$v';
                          offsetCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: offsetCtrl.text.length),
                          );
                          _applyOffset();
                        },
                        icon: const Icon(Symbols.add),
                      ),
                      IconButton(
                        tooltip: 'Decrement',
                        onPressed: () {
                          final v = (parseOffset().abs() - 1).clamp(0, 1000000);
                          offsetCtrl.text = '$v';
                          offsetCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: offsetCtrl.text.length),
                          );
                          _applyOffset();
                        },
                        icon: const Icon(Symbols.remove),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Selection chips (no close, just selection)
              Row(
                children: [
                  ChoiceChip(
                    avatar: const Icon(Symbols.history, size: 18),
                    label: Text(loc.x_days_ago),
                    selected: offsetDirection == -1,
                    onSelected: (sel) {
                      setState(() {
                        offsetDirection = sel ? -1 : 0;
                      });
                      _applyOffset();
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    avatar: const Icon(Symbols.schedule, size: 18),
                    label: Text(loc.in_x_days),
                    selected: offsetDirection == 1,
                    onSelected: (sel) {
                      setState(() {
                        offsetDirection = sel ? 1 : 0;
                      });
                      _applyOffset();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
