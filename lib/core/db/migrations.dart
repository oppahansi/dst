// Package Imports
import "package:sqflite/sqflite.dart";

typedef Migration = Future<void> Function(Database db);

class DbMigrations {
  // Key = target version. Each step upgrades from (version-1) -> version.
  static final Map<int, Migration> upgraders = <int, Migration>{
    // 1: baseline. If you ship an asset that already contains the full v1 schema,
    // you typically don't need to do anything here.
    1: (db) async {
      // No-op (asset contains v1 schema). Keep for completeness.
    },

    // // 2: Add days_since_entries table
    // 2: (db) async {
    //   await db.execute('''
    //     CREATE TABLE days_since_entries (
    //       id INTEGER PRIMARY KEY AUTOINCREMENT,
    //       title TEXT NOT NULL,
    //       date TEXT NOT NULL,
    //       description TEXT,
    //       image_url TEXT,
    //       display_mode TEXT NOT NULL
    //     )''');
    // },

    // // 3: Add stylized_layout to days_since_entries
    // 3: (db) async {
    //   await db.execute('''
    //     ALTER TABLE days_since_entries
    //     ADD COLUMN stylized_layout TEXT NOT NULL DEFAULT '${StylizedLayoutMode.defaultLayout.name}'
    //   ''');
    // },

    // // 4: Add stylized_settings to days_since_entries
    // 4: (db) async {
    //   await db.execute('''
    //     ALTER TABLE days_since_entries
    //     ADD COLUMN stylized_settings TEXT
    //   ''');
    // },
  };

  static Future<void> run(Database db, int from, int to) async {
    for (var v = from + 1; v <= to; v++) {
      final step = upgraders[v];
      if (step != null) {
        await step(db);
      }
    }
  }
}
