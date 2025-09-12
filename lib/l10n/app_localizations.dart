import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get dark;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'englisch'**
  String get english;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// No description provided for @default_key.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_key;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'german'**
  String get german;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get language;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get light;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @overlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay'**
  String get overlay;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @outlined.
  ///
  /// In en, this message translates to:
  /// **'Outlined'**
  String get outlined;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settings;

  /// No description provided for @simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get simple;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @slim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get slim;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get system;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'theme'**
  String get theme;

  /// No description provided for @thick.
  ///
  /// In en, this message translates to:
  /// **'Thick'**
  String get thick;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @transparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get transparency;

  /// No description provided for @customize_style.
  ///
  /// In en, this message translates to:
  /// **'Customize Style'**
  String get customize_style;

  /// No description provided for @days_counter_text.
  ///
  /// In en, this message translates to:
  /// **'Days Counter Text'**
  String get days_counter_text;

  /// No description provided for @days_since.
  ///
  /// In en, this message translates to:
  /// **'Days Since'**
  String get days_since;

  /// No description provided for @days_to.
  ///
  /// In en, this message translates to:
  /// **'Days To'**
  String get days_to;

  /// No description provided for @date_format.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get date_format;

  /// No description provided for @delete_entry_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry?'**
  String get delete_entry_title;

  /// No description provided for @description_optional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get description_optional;

  /// No description provided for @divider_thickness.
  ///
  /// In en, this message translates to:
  /// **'Divider Thickness'**
  String get divider_thickness;

  /// No description provided for @font_family.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get font_family;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get font_size;

  /// No description provided for @image_optional.
  ///
  /// In en, this message translates to:
  /// **'Image (Optional)'**
  String get image_optional;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get load_more;

  /// No description provided for @new_event.
  ///
  /// In en, this message translates to:
  /// **'New Event'**
  String get new_event;

  /// No description provided for @remove_image.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get remove_image;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @screenshot_view.
  ///
  /// In en, this message translates to:
  /// **'Screenshot View'**
  String get screenshot_view;

  /// No description provided for @show_date.
  ///
  /// In en, this message translates to:
  /// **'Show Date'**
  String get show_date;

  /// No description provided for @subtitle_text.
  ///
  /// In en, this message translates to:
  /// **'Subtitle Text'**
  String get subtitle_text;

  /// No description provided for @take_screenshot.
  ///
  /// In en, this message translates to:
  /// **'Take Screenshot'**
  String get take_screenshot;

  /// No description provided for @title_text.
  ///
  /// In en, this message translates to:
  /// **'Title Text'**
  String get title_text;

  /// No description provided for @view_license.
  ///
  /// In en, this message translates to:
  /// **'View license'**
  String get view_license;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choose_from_gallery;

  /// No description provided for @could_not_launch_url.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String could_not_launch_url(Object url);

  /// No description provided for @days_since_title.
  ///
  /// In en, this message translates to:
  /// **'days since {title}'**
  String days_since_title(Object title);

  /// No description provided for @delete_entry_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry? This action cannot be undone.'**
  String get delete_entry_confirmation;

  /// No description provided for @failed_to_load_images.
  ///
  /// In en, this message translates to:
  /// **'Failed to load images.'**
  String get failed_to_load_images;

  /// No description provided for @no_description_to_print.
  ///
  /// In en, this message translates to:
  /// **'No description to print.'**
  String get no_description_to_print;

  /// No description provided for @no_images_found.
  ///
  /// In en, this message translates to:
  /// **'No images found.'**
  String get no_images_found;

  /// No description provided for @please_enter_a_title.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get please_enter_a_title;

  /// No description provided for @please_select_a_date.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get please_select_a_date;

  /// No description provided for @prompt_for_exit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit the app.'**
  String get prompt_for_exit;

  /// No description provided for @screenshot_saved.
  ///
  /// In en, this message translates to:
  /// **'Screenshot saved to gallery'**
  String get screenshot_saved;

  /// No description provided for @search_for_an_image.
  ///
  /// In en, this message translates to:
  /// **'Search for an image...'**
  String get search_for_an_image;

  /// No description provided for @select_a_date.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get select_a_date;

  /// No description provided for @select_an_image.
  ///
  /// In en, this message translates to:
  /// **'Select an Image'**
  String get select_an_image;

  /// No description provided for @search_online.
  ///
  /// In en, this message translates to:
  /// **'Search online'**
  String get search_online;

  /// No description provided for @since_date.
  ///
  /// In en, this message translates to:
  /// **'since {date}'**
  String since_date(Object date);

  /// No description provided for @tap_to_change_the_image.
  ///
  /// In en, this message translates to:
  /// **'Tap to change the image'**
  String get tap_to_change_the_image;

  /// No description provided for @take_a_picture.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get take_a_picture;

  /// No description provided for @tap_to_select_an_image.
  ///
  /// In en, this message translates to:
  /// **'Tap to select an image'**
  String get tap_to_select_an_image;

  /// No description provided for @view_on_source_page.
  ///
  /// In en, this message translates to:
  /// **'View on source page'**
  String get view_on_source_page;

  /// No description provided for @tap_edit_to_add_description.
  ///
  /// In en, this message translates to:
  /// **'Tap edit to add a description'**
  String get tap_edit_to_add_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
