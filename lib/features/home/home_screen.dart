// Package Imports
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdtpro/app/main_screen.dart" show currentTabIndexProvider;
import "package:sdtpro/core/widgets/debug_settings_controlls.dart";
import "package:sdtpro/features/sdt/view/providers/sdt_provider.dart";
import "package:sdtpro/features/sdt/view/widgets/ds_card.dart";
import "package:sdtpro/l10n/app_localizations.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String path = "/home";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    // CHANGED: use filtered providers
    final sinceAsync = ref.watch(dsNotifierProvider);
    final toAsync = ref.watch(dtNotifierProvider);

    if (sinceAsync.isLoading || toAsync.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (sinceAsync.hasError) {
      return Center(child: Text(sinceAsync.error.toString()));
    }
    if (toAsync.hasError) {
      return Center(child: Text(toAsync.error.toString()));
    }

    final since = sinceAsync.value ?? const [];
    final to = toAsync.value ?? const [];
    const sectionLimit = 3;

    final sinceTop = since.take(sectionLimit).toList();
    final toTop = to.take(sectionLimit).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (kDebugMode) const DebugSettingsControlls(),
          _SectionHeader(
            title: loc.days_since,
            icon: Symbols.calendar_month,
            onTap: () => ref.read(currentTabIndexProvider.notifier).state = 1,
          ),
          const SizedBox(height: 8),
          if (sinceTop.isEmpty)
            const SizedBox.shrink()
          else
            ...sinceTop
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SdtCard(entry: e),
                  ),
                )
                .toList(),
          const SizedBox(height: 16),
          _SectionHeader(
            title: loc.days_to,
            icon: Symbols.calendar_today,
            onTap: () => ref.read(currentTabIndexProvider.notifier).state = 2,
          ),
          const SizedBox(height: 8),
          if (toTop.isEmpty)
            const SizedBox.shrink()
          else
            ...toTop
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SdtCard(entry: e),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
        IconButton(tooltip: title, icon: Icon(icon), onPressed: onTap),
      ],
    );
  }
}
