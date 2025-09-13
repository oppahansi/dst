import "package:flutter/material.dart";
import "banner_ad_widget.dart";

class AdsScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final bool showBanner;
  final Widget? drawer; // ads branch addition
  final Widget? floatingActionButton; // optional (future use)
  final bool resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final bool? extendBodyBehindAppBar;

  const AdsScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.backgroundColor,
    this.showBanner = true,
    this.drawer,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      drawer: drawer, // ads branch addition
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar!,
      body: Column(
        children: [
          Expanded(child: body),
          if (showBanner) const BannerAdContainer(),
        ],
      ),
    );
  }
}
