// Package Imports
import "package:flutter/material.dart";

// Define the seed color for your theme
const seedColor = Color.fromRGBO(37, 105, 122, 1);

// Light theme data
final light = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  ),
  visualDensity: VisualDensity.comfortable,
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    filled: true,
    border: OutlineInputBorder(),
  ),
  navigationRailTheme: const NavigationRailThemeData(useIndicator: true),
);

// Dark theme data
final dark = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  visualDensity: VisualDensity.comfortable,
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
    filled: true,
    border: OutlineInputBorder(),
  ),
  navigationRailTheme: const NavigationRailThemeData(useIndicator: true),
);
