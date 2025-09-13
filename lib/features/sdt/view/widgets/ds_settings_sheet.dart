// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Project Imports
// NEW
import 'package:sdtpro/core/utils/colors.dart';
import 'package:sdtpro/core/utils/constants.dart';
import 'package:sdtpro/core/utils/extensions.dart';
import 'package:sdtpro/core/utils/text_styles.dart';
import 'package:sdtpro/features/sdt/domain/entities/sdt_settings.dart';
import 'package:sdtpro/l10n/app_localizations.dart';

/// A bottom sheet for editing the stylized settings.
class SdtSettingsSheet extends StatefulWidget {
  final SdtSettings settings;
  final ValueChanged<SdtSettings> onSettingsChanged;
  final ScrollController scrollController;

  const SdtSettingsSheet({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.scrollController,
  });

  @override
  State<SdtSettingsSheet> createState() => _SdtSettingsSheetState();
}

class _SdtSettingsSheetState extends State<SdtSettingsSheet> {
  late SdtSettings _localSettings;

  @override
  void initState() {
    super.initState();
    // Create a local copy to manage the state within the sheet.
    _localSettings = widget.settings;
  }

  void _showIconPicker() {
    showModalBottomSheet<IconData>(
      context: context,
      builder: (context) => SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: eventIcons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final icon = eventIcons[index];
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

  // Dialog to pick any color
  Future<void> _showAdvancedColorPicker({
    required String title,
    required Color initialColor,
    required ValueChanged<Color> onColorSelected,
  }) async {
    var temp = initialColor;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: temp,
            onColorChanged: (c) => temp = c,
            enableAlpha: true,
            displayThumbColor: true,
            pickerAreaHeightPercent: 0.7,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onColorSelected(temp);
              Navigator.pop(context);
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
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
          (color) => _updateSettings((s) => s.copyWith(overlayColor: color)),
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
          color: _localSettings.daysColor,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(daysFontWeight: val)),
        ),
        // REPLACED: swatches + button -> button + current color only
        _buildColorPicker(
          loc.color,
          _localSettings.daysColor,
          (color) => _updateSettings((s) => s.copyWith(daysColor: color)),
        ),
        const Divider(height: 32),

        // --- Title Text ---
        _buildSectionHeader(loc.title_text),
        _buildFontControl(
          previewText: loc.title,
          fontFamily: _localSettings.titleFontFamily,
          fontSize: _localSettings.titleFontSize,
          fontWeight: _localSettings.titleFontWeight,
          color: _localSettings.titleColor,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(titleFontWeight: val)),
        ),
        // REPLACED: swatches + button -> button + current color only
        _buildColorPicker(
          loc.color,
          _localSettings.titleColor,
          (color) => _updateSettings((s) => s.copyWith(titleColor: color)),
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
            items: eventDateFormats.entries
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
          color: _localSettings.subtitleColor,
          onFamilyChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontFamily: val)),
          onSizeChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontSize: val)),
          onWeightChanged: (val) =>
              _updateSettings((s) => s.copyWith(subtitleFontWeight: val)),
        ),
        _buildColorPicker(
          loc.color,
          _localSettings.subtitleColor,
          (color) => _updateSettings((s) => s.copyWith(subtitleColor: color)),
        ),
      ],
    );
  }

  void _updateSettings(SdtSettings Function(SdtSettings) updateFn) {
    setState(() {
      _localSettings = updateFn(_localSettings);
    });
    widget.onSettingsChanged(_localSettings);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: titleLarge(context).withColor(primaryColor(context)),
    );
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

  // Simplified color picker row: shows current color and a button to open dialog
  Widget _buildColorPicker(
    String label,
    Color currentColor,
    ValueChanged<Color> onColorSelected,
  ) {
    final onLight = currentColor.computeLuminance() > 0.5;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            // Current color chip
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                border: Border.all(
                  color: onLight ? Colors.black26 : Colors.white30,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.palette),
              label: const Text('More'),
              onPressed: () => _showAdvancedColorPicker(
                title: label,
                initialColor: currentColor,
                onColorSelected: (c) => setState(() => onColorSelected(c)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Resolve a TextStyle for a given family. 'System' falls back to base.
  TextStyle _styleForFamily(
    String family, {
    double? size,
    FontWeight? weight,
    TextStyle? base,
    // NEW
    Color? color,
  }) {
    final baseStyle = (base ?? const TextStyle()).copyWith(
      fontSize: size,
      fontWeight: weight,
      // NEW
      color: color,
    );
    if (family == 'System' || family.isEmpty) return baseStyle;

    return baseStyle.copyWith(fontFamily: family);
  }

  Widget _buildFontControl({
    required String previewText,
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    // NEW
    required Color color,
    required ValueChanged<String?> onFamilyChanged,
    required ValueChanged<double> onSizeChanged,
    required ValueChanged<FontWeight?> onWeightChanged,
  }) {
    final loc = AppLocalizations.of(context)!;
    final effectiveValue = eventFontFamilies.contains(fontFamily)
        ? fontFamily
        : 'System';

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
            style: _styleForFamily(
              fontFamily,
              size: fontSize,
              weight: fontWeight,
              // NEW
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: effectiveValue,
          decoration: InputDecoration(labelText: loc.font_family),
          items: eventFontFamilies
              .map(
                (f) => DropdownMenuItem(
                  value: f,
                  child: Text(
                    f,
                    style: _styleForFamily(
                      f,
                      base: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (context) => eventFontFamilies
              .map(
                (f) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    f,
                    style: _styleForFamily(
                      f,
                      base: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
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
                  max: 8,
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
