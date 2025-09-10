// Package Imports
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";
import "package:exui/exui.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdtpro/core/utils/colors.dart";
import "package:sdtpro/core/utils/extensions.dart";
import "package:sdtpro/features/days_since/view/widgets/add_days_since_entry_sheet.dart";
import "package:sdtpro/features/days_since/view/screens/days_since_screen.dart";
import "package:sdtpro/features/days_to/view/screens/days_to_screen.dart";
import "package:sdtpro/features/home/home_screen.dart";
import "package:sdtpro/features/settings/view/screens/settings_screen.dart";
import "package:sdtpro/l10n/app_localizations.dart";

final currentTabIndexProvider = StateProvider<int>((ref) => 0);
final lastBackPressedProvider = StateProvider<DateTime?>((ref) => null);

class MainScreen extends ConsumerStatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? lastBackPressTime;

  late final PageController pageController;
  bool isBarVisible = true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: ref.read(currentTabIndexProvider),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget? _buildFab(BuildContext context, int index) {
    final loc = AppLocalizations.of(context)!;

    // Define the onPressed callback and tooltip based on the current screen.
    final VoidCallback? onPressed;
    final String? tooltip;

    switch (index) {
      case 1: // DaysSinceScreen
        tooltip = "${loc.add} ${loc.days_since}";
        onPressed = () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows the sheet to be taller
            useSafeArea: true, // Avoids system intrusions
            builder: (context) => const AddDaysSinceEntrySheet(),
          );
        };
        break;
      case 2: // DaysToScreen
        tooltip = "${loc.add} ${loc.days_to}";
        onPressed = () {
          // TODO: Implement action for adding a "Days To" event.
          context.showSnackBar(
            SnackBar(content: Text("${loc.add} new '${loc.days_to}' event.")),
          );
        };
        break;
      default:
        // Return null for any other screen that should not have a FAB.
        return null;
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Symbols.add.icon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentTabIndexProvider);
    final loc = AppLocalizations.of(context)!;

    ref.listen(currentTabIndexProvider, (previous, next) {
      if (next != pageController.page?.round()) {
        pageController.jumpToPage(next);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final modalRoute = ModalRoute.of(context);
        if (modalRoute?.isCurrent == false) {
          context.pop();
          return;
        }

        final now = DateTime.now();
        const duration = Duration(seconds: 2);

        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > duration) {
          lastBackPressTime = now;
          context.showSnackBar(
            SnackBar(content: loc.prompt_for_exit.text(), duration: duration),
          );

          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        floatingActionButton: _buildFab(context, currentIndex),
        backgroundColor: surfaceDimColor(context),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            ref.read(currentTabIndexProvider.notifier).state = index;
          },
          children: [
            HomeScreen(),
            DaysSinceScreen(),
            DaysToScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryColor(context),
          selectedIconTheme: IconThemeData(
            color: secondaryColor(context),
            size: 32,
          ),
          unselectedIconTheme: IconThemeData(
            color: primaryColor(context),
            size: 24,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          onTap: (index) {
            ref.read(currentTabIndexProvider.notifier).state = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Symbols.home.icon(),
              label: loc.home.capitalize(),
            ),
            BottomNavigationBarItem(
              icon: Symbols.calendar_month.icon(),
              label: loc.days_since.capitalize(),
            ),
            BottomNavigationBarItem(
              icon: Symbols.calendar_today.icon(),
              label: loc.days_to.capitalize(),
            ),

            BottomNavigationBarItem(
              icon: Symbols.settings.icon(),
              label: loc.settings.capitalize(),
            ),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ).safeArea(),
    );
  }
}

int getRouteIndex(String path) {
  final bottomRoutes = [
    HomeScreen.path,
    DaysSinceScreen.path,
    DaysToScreen.path,
    SettingsScreen.path,
  ];

  return bottomRoutes.indexWhere((route) => route == path);
}
