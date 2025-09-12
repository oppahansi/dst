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
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/features/days_since/view/screens/stylized_ds_background_image.dart';
import 'package:sdtpro/features/days_since/view/screens/stylized_ds_content.dart';
import 'package:sdtpro/features/days_since/view/screens/stylized_settings_sheet.dart';
import 'package:sdtpro/features/images/domain/entities/fis_image.dart';
import 'package:sdtpro/features/images/view/providers/image_provider.dart';
import 'package:sdtpro/features/images/view/screens/image_search_screen.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class AddStylizedDsScreen extends ConsumerStatefulWidget {
  final DaysSinceEntry? entry;

  const AddStylizedDsScreen({super.key, this.entry});

  static final String path = '/add-stylized-days-since-entry';

  @override
  ConsumerState<AddStylizedDsScreen> createState() =>
      _AddStylizedDsScreenState();
}

class _AddStylizedDsScreenState extends ConsumerState<AddStylizedDsScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  FisImage? _selectedImage;

  bool get _isEditing => widget.entry != null;

  bool _showUiElements = true;
  // State for all the new stylized settings
  late StylizedSettings _settings;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final entry = widget.entry!;
      _settings = entry.stylizedSettings ?? StylizedSettings();
      _selectedDate = entry.date;
      _titleController.text = entry.title;
      if (entry.imageUrl != null) {
        _selectedImage = FisImage(
          url: entry.imageUrl!,
          preview: entry.imageUrl!,
        );
      }
    } else {
      _settings = StylizedSettings();
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
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(
        () => _selectedImage = FisImage(
          url: pickedFile.path,
          preview: pickedFile.path,
        ),
      );
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

    if (_isEditing) {
      final updatedEntry = widget.entry!.copyWith(
        title: _titleController.text,
        date: _selectedDate,
        imageUrl: _selectedImage?.url,
        stylizedSettings: _settings,
      );
      await ref
          .read(daysSinceNotifierProvider.notifier)
          .updateEntry(updatedEntry);
    } else {
      final newEntry = DaysSinceEntry(
        title: _titleController.text,
        date: _selectedDate,
        imageUrl: _selectedImage?.url,
        displayMode: DaysSinceDisplayMode.stylized,
        stylizedSettings: _settings,
      );
      await ref.read(daysSinceNotifierProvider.notifier).addEntry(newEntry);
    }

    if (mounted) {
      // Pop twice if editing to get back to the list screen
      if (_isEditing) {
        context.pop();
      }
      context.pop();
    }
  }

  void _showSettingsPanel() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => StylizedSettingsSheet(
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
            StylizedDsBackgroundImage(imageUrl: _selectedImage?.url),

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
            StylizedDsContent(
              entry: DaysSinceEntry(
                title: _titleController.text,
                date: _selectedDate,
                displayMode: DaysSinceDisplayMode.stylized,
              ),
              settings: _settings,
              contentContext: StylizedContentContext.editor,
              titleController: _titleController,
            ),
          ],
        ),
      ),
    );
  }
}
