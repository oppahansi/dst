// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdtpro/features/days_since/domain/entities/ds_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

/// A bottom sheet for editing the stylized settings.
class DsSettingsSheet extends StatefulWidget {
  final DsSettings settings;
  final ValueChanged<DsSettings> onSettingsChanged;
  final ScrollController scrollController;

  const DsSettingsSheet({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.scrollController,
  });

  @override
  State<DsSettingsSheet> createState() => _DsSettingsSheetState();
}

class _DsSettingsSheetState extends State<DsSettingsSheet> {
  late DsSettings _localSettings;

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
            value: _localSettings.subtitleDateFormat,
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

  void _updateSettings(DsSettings Function(DsSettings) updateFn) {
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
                      color: currentColor.value == color.value
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
          value: fontFamily,
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
