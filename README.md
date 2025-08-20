## Overview
This repository is a reusable base template for new Flutter apps. It provides a clean app shell, theming, localization, state management, and a versioned local database layer to accelerate new project setup.

## Features
- Theming
  - Light/Dark themes with a modern Material 3 look (FlexColorScheme).
- Localization
  - Flutter localization wiring with ARB-based strings (intl).
- State management
  - Riverpod setup with annotations and code generation for Notifiers.
- Persistence
  - Local database via sqflite, with versioned migration scaffolding.
- Developer experience
  - Strong static analysis with configured lints.
  - VS Code launch configurations included.
- Platform
  - Android and iOS targets preconfigured for a smooth start.

## Tech stack
- Flutter, Material 3
- flutter_localizations, intl
- riverpod / flutter_riverpod, riverpod_annotation
- sqflite, path, path_provider
- flex_color_scheme
- material_symbols_icons

## License
Licensed under the MIT License. See [LICENSE](LICENSE) for details.

## App Store Badges Placeholder
[<img src="res/GetItOnAppStore_Badge.png" alt="Get it on Google Play" height="55" />](https://apps.apple.com/app/id0000000000)
[<img src="res/GetItOnGooglePlay_Badge.png" alt="Get it on Google Play" height="55" />](https://play.google.com/store/apps/details?id=de.oppahansi.where_is_my_sht)