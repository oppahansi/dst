// Dart Imports
import 'dart:math';
import 'dart:io';

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/features/days_since/domain/entities/days_since_entry.dart';
import 'package:sdtpro/features/days_since/domain/entities/stylized_settings.dart';
import 'package:sdtpro/features/days_since/view/providers/days_since_provider.dart';
import 'package:sdtpro/features/images/domain/entities/fis_image.dart';
import 'package:sdtpro/features/images/view/providers/image_provider.dart';
import 'package:sdtpro/features/images/view/screens/image_search_screen.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

class AddStylizedDaysSinceEntryScreen extends ConsumerStatefulWidget {
  final DaysSinceEntry? entry;

  const AddStylizedDaysSinceEntryScreen({super.key, this.entry});

  static final String path = '/add-stylized-days-since-entry';

  @override
  ConsumerState<AddStylizedDaysSinceEntryScreen> createState() =>
      _AddStylizedDaysSinceEntryScreenState();
}

class _AddStylizedDaysSinceEntryScreenState
    extends ConsumerState<AddStylizedDaysSinceEntryScreen> {
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
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => _StylizedSettingsSheet(
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
    final days = DateTime.now().difference(_selectedDate).inDays;

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
            // Background Image (handles both network and local files)
            if (_selectedImage != null) ...[
              if (_selectedImage!.url.startsWith('http'))
                CachedNetworkImage(
                  imageUrl: _selectedImage!.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              else
                Image.file(
                  File(_selectedImage!.url),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
            ] else
              Container(color: Colors.grey[800]),

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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$days',
                      style: TextStyle(
                        fontFamily: _settings.daysFontFamily == 'System'
                            ? null
                            : _settings.daysFontFamily,
                        fontSize: _settings.daysFontSize,
                        color: Colors.white,
                        fontWeight: _settings.daysFontWeight,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54),
                        ],
                      ),
                    ),
                    Text(
                      _settings.showSubtitleDate
                          ? '${loc.days_since} ${DateFormat(_settings.subtitleDateFormat, loc.localeName).format(_selectedDate)}'
                          : loc.days_since,
                      style: TextStyle(
                        fontFamily: _settings.subtitleFontFamily == 'System'
                            ? null
                            : _settings.subtitleFontFamily,
                        color: _settings.subtitleColor,
                        fontSize: _settings.subtitleFontSize,
                        fontWeight: _settings.subtitleFontWeight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white70,
                            thickness: _settings.dividerThickness,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            _settings.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white70,
                            thickness: _settings.dividerThickness,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      textAlign: TextAlign.center,
                      maxLines: null,
                      style: TextStyle(
                        fontFamily: _settings.titleFontFamily == 'System'
                            ? null
                            : _settings.titleFontFamily,
                        color: Colors.white,
                        fontSize: _settings.titleFontSize,
                        fontWeight: _settings.titleFontWeight,
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black45),
                        ],
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        hintText: loc.title,
                        hintStyle: TextStyle(
                          color: Colors.white.withAlpha(128),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A bottom sheet for editing the stylized settings.
class _StylizedSettingsSheet extends StatefulWidget {
  final StylizedSettings settings;
  final ValueChanged<StylizedSettings> onSettingsChanged;
  final ScrollController scrollController;

  const _StylizedSettingsSheet({
    required this.settings,
    required this.onSettingsChanged,
    required this.scrollController,
  });

  @override
  State<_StylizedSettingsSheet> createState() => __StylizedSettingsSheetState();
}

class __StylizedSettingsSheetState extends State<_StylizedSettingsSheet> {
  late StylizedSettings _localSettings;

  @override
  void initState() {
    super.initState();
    // Create a local copy to manage the state within the sheet.
    _localSettings = widget.settings;
  }

  // A few font families to choose from.
  final _fontFamilies = ['System', 'Serif', 'Monospace'];
  final Map<String, String> _dateFormats = {
    'yMMMd': 'Sep 1, 2023',
    'yMd': '9/1/2023',
    'MMMMd': 'September 1',
    'E, d MMM': 'Fri, 1 Sep',
  };

  // A curated list of icons for the picker.
  final _icons = [
    Symbols.star,
    Symbols.favorite,
    Symbols.anchor,
    Symbols.work,
    Symbols.flag,
    Symbols.celebration,
    Symbols.cake,
    Symbols.directions_run,
    Symbols.flight_takeoff,
    Symbols.home,
    Symbols.school,
    Symbols.pets,
    Symbols.work,
    Symbols.fitness_center,
    Symbols.book,
    Symbols.music_note,
    Symbols.movie,
    Symbols.camera_alt,
    Symbols.brush,
    Symbols.lightbulb,
    Symbols.forest,
    Symbols.beach_access,
    Symbols.pool,
    Symbols.sports_soccer,
    Symbols.downhill_skiing,
    Symbols.hiking,
    Symbols.rowing,
    Symbols.sailing,
    Symbols.scuba_diving,
    Symbols.skateboarding,
    Symbols.snowboarding,
    Symbols.surfing,
    Symbols.kitesurfing,
    Symbols.paragliding,
    Symbols.directions_bike,
    Symbols.directions_boat,
    Symbols.directions_bus,
    Symbols.directions_car,
    Symbols.directions_railway,
    Symbols.directions_walk,
    Symbols.flight,
    Symbols.train,
    Symbols.tram,
    Symbols.local_fire_department,
    Symbols.local_hospital,
    Symbols.local_police,
    Symbols.local_post_office,
    Symbols.local_cafe,
    Symbols.local_bar,
    Symbols.local_dining,
    Symbols.local_florist,
    Symbols.local_gas_station,
    Symbols.local_grocery_store,
    Symbols.local_laundry_service,
    Symbols.local_library,
    Symbols.local_mall,
    Symbols.local_pharmacy,
    Symbols.local_shipping,
    Symbols.local_taxi,
    Symbols.park,
    Symbols.museum,
    Symbols.church,
    Symbols.mosque,
    Symbols.synagogue,
    Symbols.temple_buddhist,
    Symbols.temple_hindu,
    Symbols.factory,
    Symbols.gavel,
    Symbols.military_tech,
    Symbols.science,
    Symbols.engineering,
    Symbols.build,
    Symbols.construction,
  ];

  // A few colors for the overlay picker.
  final _overlayColors = [
    Colors.black,
    Colors.grey[850]!,
    Colors.blueGrey[900]!,
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
  ];

  void _showIconPicker() {
    showModalBottomSheet<IconData>(
      context: context,
      builder: (context) => SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final icon = _icons[index];
            return InkWell(
              onTap: () => Navigator.of(context).pop(icon),
              child: Icon(icon, size: 32),
            );
          },
        ),
      ),
    ).then((selectedIcon) {
      if (selectedIcon != null) {
        setState(() {
          _localSettings = _localSettings.copyWith(icon: selectedIcon);
        });
        widget.onSettingsChanged(_localSettings);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          loc.customize_style,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(height: 32),

        // --- Overlay Settings ---
        _buildSectionHeader(loc.overlay),
        _buildColorPicker(
          loc.color,
          _localSettings.overlayColor,
          _overlayColors,
          (color) {
            setState(
              () =>
                  _localSettings = _localSettings.copyWith(overlayColor: color),
            );
            widget.onSettingsChanged(_localSettings);
          },
        ),
        _buildSlider(loc.transparency, _localSettings.overlayAlpha, 0.0, 1.0, (
          val,
        ) {
          setState(
            () => _localSettings = _localSettings.copyWith(overlayAlpha: val),
          );
          widget.onSettingsChanged(_localSettings);
        }),
        const Divider(height: 32),

        // --- Content Settings ---
        _buildSectionHeader(loc.content),
        ListTile(
          leading: const Icon(Symbols.interests),
          title: Text(loc.icon),
          trailing: Icon(_localSettings.icon),
          onTap: _showIconPicker,
        ),
        _buildSlider(
          loc.divider_thickness,
          _localSettings.dividerThickness,
          0.5,
          5.0,
          (val) {
            setState(
              () => _localSettings = _localSettings.copyWith(
                dividerThickness: val,
              ),
            );
            widget.onSettingsChanged(_localSettings);
          },
        ),
        const Divider(height: 32),

        // --- Days Text ---
        _buildSectionHeader(loc.days_counter_text),
        _buildFontControl(
          previewText: '123',
          fontFamily: _localSettings.daysFontFamily,
          fontSize: _localSettings.daysFontSize,
          fontWeight: _localSettings.daysFontWeight,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontWeight: val)),
        ),
        const Divider(height: 32),

        // --- Title Text ---
        _buildSectionHeader(loc.title_text),
        _buildFontControl(
          previewText: loc.title,
          fontFamily: _localSettings.titleFontFamily,
          fontSize: _localSettings.titleFontSize,
          fontWeight: _localSettings.titleFontWeight,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontWeight: val)),
        ),
        const Divider(height: 32),

        // --- Subtitle Text ---
        _buildSectionHeader(loc.subtitle_text),
        SwitchListTile(
          title: Text(loc.show_date),
          value: _localSettings.showSubtitleDate,
          onChanged: (value) {
            _updateSettings((s) => s.copyWith(showSubtitleDate: value));
          },
          contentPadding: EdgeInsets.zero,
        ),
        if (_localSettings.showSubtitleDate)
          DropdownButtonFormField<String>(
            initialValue: _localSettings.subtitleDateFormat,
            decoration: InputDecoration(labelText: loc.date_format),
            items: _dateFormats.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                _updateSettings((s) => s.copyWith(subtitleDateFormat: value));
              }
            },
          ),
        _buildFontControl(
          previewText: _localSettings.showSubtitleDate
              ? '${loc.days_since} ${DateFormat(_localSettings.subtitleDateFormat, loc.localeName).format(DateTime.now())}'
              : loc.days_since,
          fontFamily: _localSettings.subtitleFontFamily,
          fontSize: _localSettings.subtitleFontSize,
          fontWeight: _localSettings.subtitleFontWeight,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontWeight: val)),
        ),
      ],
    );
  }

  void _updateSettings(StylizedSettings Function(StylizedSettings) updateFn) {
    setState(() {
      _localSettings = updateFn(_localSettings);
    });
    widget.onSettingsChanged(_localSettings);
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Slider(value: value, min: min, max: max, onChanged: onChanged),
      trailing: Text(value.toStringAsFixed(1)),
    );
  }

  Widget _buildColorPicker(
    String label,
    Color currentColor,
    List<Color> colors,
    ValueChanged<Color> onColorSelected,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Wrap(
        spacing: 8,
        children: colors
            .map(
              (color) => InkWell(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: currentColor == color
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFontControl({
    required String previewText,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required ValueChanged<String?> onFamilyChanged,
    required ValueChanged<double> onSizeChanged,
    required ValueChanged<FontWeight?> onWeightChanged,
  }) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            previewText,
            style: TextStyle(
              fontFamily: fontFamily == 'System' ? null : fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: fontFamily,
          decoration: InputDecoration(labelText: loc.font_family),
          items: _fontFamilies
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: onFamilyChanged,
        ),
        const SizedBox(height: 8),
        // Font Weight Slider
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Text(loc.slim),
              Expanded(
                child: Slider(
                  value: fontWeight.index.toDouble(),
                  min: 0,
                  max: 8, // FontWeight.values has 9 values (w100 to w900)
                  divisions: 8,
                  label: 'w${((fontWeight.index + 1) * 100)}',
                  onChanged: (value) {
                    final newWeight = FontWeight.values[value.round()];
                    onWeightChanged(newWeight);
                  },
                ),
              ),
              Text(loc.thick),
            ],
          ),
        ),
        _buildSlider(loc.font_size, fontSize, 8.0, 150.0, onSizeChanged),
      ],
    );
  }
}
