// Flutter Imports
import 'package:flutter/material.dart';

// Package Imports
import 'package:material_symbols_icons/symbols.dart';

const String appName = "SDT";
const String appTitle = "Since Days To";
const String dataDbName = "sdt_data.db";
const String dataDbPath = "assets/db/$dataDbName";
const String userDbNane = "sdt_user.db";
const String userDbPath = "assets/db/$userDbNane";

const String settingsTable = "settings";
const String settingsKeyLocale = "locale";
const String settingsValueLocaleDefault = "en";
const String settingsKeyThemeMode = "theme_mode";
const String settingsValueThemeModeSystem = "system";
const String settingsValueThemeModeLight = "light";
const String settingsValueThemeModeDark = "dark";

const String fisApiKey = "123456789abcdef";
const String fisApiBaseUrl = "https://sdt.oppahansi.de:8880";

const Set<String> eventFontFamilies = {
  'System', // default platform font
  // Feeling sub-level categories
  "Roboto", // Business
  "Lobster", // Fancy
  "Lora", // Calm
  "Pacifico", // Playful
  "Amatic SC", // Cute
  "Caveat", // Artistic
  "Vollkorn", // Vintage
  "Bangers", // Loud
  "Playfair Display", // Sophisticated
  "Orbitron", // Futuristic
  "Montserrat", // Active
  "Merriweather", // Stiff
  "Source Code Pro", // Innovative
  "Open Sans", // Happy
  "Indie Flower", // Childlike
  "Oswald", // Rugged
  "Architects Daughter", // Awkward
  "Raleway", // Excited
  // Appearance sub-level categories
  "Fira Code", // Techno
  "Inconsolata", // Monospaced
  "Satisfy", // Blobby
  "Permanent Marker", // Marker
  "Cinzel", // Art Deco
  "Special Elite", // Distressed
  "Nosifer", // Stencil
  "Fredericka the Great", // Wood type
  "UnifrakturMaguntia", // Medieval
  "Zilla Slab", // Blackletter
  "Press Start 2P", // Pixel
  "Noto Emoji", // Not text
  "Rye", // Tuscan
  "Creepster", // Wacky
  "Shadows Into Light", // Shaded
  "Bungee Inline", // Inline
  // Calligraphy sub-level categories
  "Great Vibes", // Handwritten
  "Sacramento", // Formal
  "Kalam", // Informal
  "Tangerine", // Upright
  // Serif sub-level categories
  "Crimson Text", // Transitional
  "Roboto Slab", // Slab
  "EB Garamond", // Old Style
  "Cardo", // Modern
  "Arvo", // Humanist
  "Bitter", // Scotch
  "Libre Baskerville", // Didone
  // Sans Serif sub-level categories
  "Lato", // Humanist
  "Poppins", // Geometric
  "Noto Sans JP", // Rounded
  "Work Sans", // Superellipse
  "Inter", // Grotesque
  "Julius Sans One", // Glyphic
  // Technology sub-level categories
  "Noto Sans", // Variable
  "Noto Color Emoji", // Color
  // Seasonal sub-level categories
  "Red Hat Display", // Lunar New Year
  "Dancing Script", // Valentine's
  "Hind", // Holi
  "Noto Serif Devanagari", // Diwali
  "Mountains of Christmas", // Christmas
  "Noto Sans Hebrew", // Hanukkah
  "Noto Serif", // Kwanzaa
};

const Map<String, String> eventDateFormats = {
  'MM/dd/yyyy': '09/01/2023', // US numeric
  'dd.MM.yyyy': '01.09.2023', // German/European numeric
  'MMMM d, yyyy': 'September 1, 2023', // US long
  'd. MMMM yyyy': '1. September 2023', // German long
  'd MMM yyyy': '1 Sep 2023', // European short
  'MMM d, yyyy': 'Sep 1, 2023', // US short
  'yyyy-MM-dd': '2023-09-01', // ISO
  'EEEE, MMMM d, yyyy': 'Friday, September 1, 2023', // Full weekday
  'EEE, MMM d, yyyy': 'Fri, Sep 1, 2023', // Abbreviated weekday
};

const List<IconData> eventIcons = [
  Symbols.star,
  Symbols.favorite,
  Symbols.anchor,
  Symbols.work,
  Symbols.flag,
  Symbols.celebration,
  Symbols.cake,
  Symbols.directions_run,
  Symbols.flight_takeoff,
  Symbols.home,
  Symbols.school,
  Symbols.pets,
  Symbols.work,
  Symbols.fitness_center,
  Symbols.book,
  Symbols.music_note,
  Symbols.movie,
  Symbols.camera_alt,
  Symbols.brush,
  Symbols.lightbulb,
  Symbols.forest,
  Symbols.beach_access,
  Symbols.pool,
  Symbols.sports_soccer,
  Symbols.downhill_skiing,
  Symbols.hiking,
  Symbols.rowing,
  Symbols.sailing,
  Symbols.scuba_diving,
  Symbols.skateboarding,
  Symbols.snowboarding,
  Symbols.surfing,
  Symbols.kitesurfing,
  Symbols.paragliding,
  Symbols.directions_bike,
  Symbols.directions_boat,
  Symbols.directions_bus,
  Symbols.directions_car,
  Symbols.directions_railway,
  Symbols.directions_walk,
  Symbols.flight,
  Symbols.train,
  Symbols.tram,
  Symbols.local_fire_department,
  Symbols.local_hospital,
  Symbols.local_police,
  Symbols.local_post_office,
  Symbols.local_cafe,
  Symbols.local_bar,
  Symbols.local_dining,
  Symbols.local_florist,
  Symbols.local_gas_station,
  Symbols.local_grocery_store,
  Symbols.local_laundry_service,
  Symbols.local_library,
  Symbols.local_mall,
  Symbols.local_pharmacy,
  Symbols.local_shipping,
  Symbols.local_taxi,
  Symbols.park,
  Symbols.museum,
  Symbols.church,
  Symbols.mosque,
  Symbols.synagogue,
  Symbols.temple_buddhist,
  Symbols.temple_hindu,
  Symbols.factory,
  Symbols.gavel,
  Symbols.military_tech,
  Symbols.science,
  Symbols.engineering,
  Symbols.build,
  Symbols.construction,
];
