// Flutter Imports
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";

// Package Imports
import "package:exui/exui.dart";
import "package:material_symbols_icons/symbols.dart";

// Project Imports
import "package:sdtpro/core/utils/colors.dart";
import "package:sdtpro/core/utils/extensions.dart";
import "package:sdtpro/features/home/home_screen.dart";
import "package:sdtpro/features/settings/settings_screen.dart";
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
      child:
          Scaffold(
            resizeToAvoidBottomInset: true,
            key: scaffoldKey,
            backgroundColor: surfaceDimColor(context),
            body: PageView(
              controller: pageController,
              onPageChanged: (index) {
                ref.read(currentTabIndexProvider.notifier).state = index;
              },
              children: [HomeScreen(), SettingsScreen()],
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
  final bottomRoutes = [HomeScreen.path, SettingsScreen.path];

  return bottomRoutes.indexWhere((route) => route == path);
}
