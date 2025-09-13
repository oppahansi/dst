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

class CountTodaySetting extends ConsumerWidget {
  const CountTodaySetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(settingsNotifierProvider);
    final loc = AppLocalizations.of(context)!;

    return ListTile(
      leading: Symbols.calculate.icon(),
      title: Text(loc.count_today, style: titleSmall(context)),
      subtitle: Text(
        app.countToday ? loc.today_is_counted : loc.today_is_not_counted,
        style: bodySmall(context),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => const _CountTodayBottomSheet(),
      ),
    );
  }
}

class _CountTodayBottomSheet extends ConsumerWidget {
  const _CountTodayBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final app = ref.watch(settingsNotifierProvider);

    // Example target: fixed calendar +3 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sample = today.add(const Duration(days: 3));
    final incl = SdtDateMath.daysBetweenToday(
      sample,
      includeToday: true,
      includeLastDay: app.countLastDay,
    );
    final excl = SdtDateMath.daysBetweenToday(
      sample,
      includeToday: false,
      includeLastDay: app.countLastDay,
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
                  loc.enable_today_counting,
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
              title: Text(loc.enable_today_counting),
              subtitle: Text(
                app.countToday
                    ? loc.the_current_day_is_counted
                    : loc.the_current_day_is_not_counted,
              ),
              value: app.countToday,
              onChanged: (v) => ref
                  .read(settingsNotifierProvider.notifier)
                  .updateCountToday(v),
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
              includeToday: true,
              value: incl,
            ),
            const SizedBox(height: 8),
            _ExampleRow(
              label: '${loc.today} → $fmt',
              includeToday: false,
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
  final bool includeToday;
  final int value;

  const _ExampleRow({
    required this.label,
    required this.includeToday,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(child: Text(label, style: bodySmall(context))),
        Text(
          includeToday
              ? '${loc.include_today}: $value'
              : '${loc.exclude_today}: $value',
          style: bodySmall(context)?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
