// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:exui/exui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project Imports
import 'package:sdt/core/utils/date_math.dart';
import 'package:sdt/core/utils/text_styles.dart';
import 'package:sdt/features/settings/view/providers/settings_provider.dart';
import 'package:sdt/l10n/app_localizations.dart';

class CountLastDaySetting extends ConsumerWidget {
  const CountLastDaySetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(settingsNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      leading: Symbols.calculate.icon(),
      title: Text(loc.count_last_day, style: titleSmall(context)),
      subtitle: Text(
        app.countLastDay
            ? loc.last_day_is_counted
            : loc.last_day_is_not_counted,
        style: bodySmall(context),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => const _CountLastDayBottomSheet(),
      ),
    );
  }
}

class _CountLastDayBottomSheet extends ConsumerWidget {
  const _CountLastDayBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final app = ref.watch(settingsNotifierProvider);

    // Example (today → +3 days)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sample = today.add(const Duration(days: 3));
    final incl = SdtDateMath.daysBetweenToday(
      sample,
      includeToday: app.countToday,
      includeLastDay: true,
    );
    final excl = SdtDateMath.daysBetweenToday(
      sample,
      includeToday: app.countToday,
      includeLastDay: false,
    );
    final fmt = DateFormat('dd.MM.yyyy', loc.localeName).format(sample);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text(
                  loc.count_last_day,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Toggle
            SwitchListTile(
              title: Text(loc.enable_last_day_counting),
              subtitle: Text(
                app.countLastDay
                    ? loc.the_target_day_is_counted
                    : loc.the_target_day_is_not_counted,
              ),
              value: app.countLastDay,
              onChanged: (v) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateCountLastDay(v),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(height: 24),

            // Examples
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                loc.examples,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            _ExampleRow(
              label: '${loc.today} → $fmt',
              includeLastDay: true,
              value: incl,
            ),
            const SizedBox(height: 8),
            _ExampleRow(
              label: '${loc.today} → $fmt',
              includeLastDay: false,
              value: excl,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final String label;
  final bool includeLastDay;
  final int value;

  const _ExampleRow({
    required this.label,
    required this.includeLastDay,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(child: Text(label, style: bodySmall(context))),
        Text(
          includeLastDay
              ? '${loc.include_last_day}: $value'
              : '${loc.exclude_last_day}: $value',
          style: bodySmall(context)?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
