// Package Imports
import 'package:sqflite/sqflite.dart';

// Project Imports
import 'package:sdtpro/core/db/db.dart';
import 'package:sdtpro/features/sdt/domain/entities/sdt_entry.dart';
import 'package:sdtpro/features/sdt/domain/repos/sdt_repo.dart';

class SdtRepoImpl implements SdtRepo {
  static final SdtRepoImpl _instance = SdtRepoImpl._internal();
  factory SdtRepoImpl() => _instance;
  SdtRepoImpl._internal();

  static const String _table = 'entries';

  Future<Database> get _db async => Db.getUserDbInstance();

  @override
  Future<SdtEntry> addEntry(SdtEntry entry) async {
    final db = await _db;
    final id = await db.insert(
      _table,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return entry.copyWith(id: id);
  }

  @override
  Future<void> deleteEntry(int id) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SdtEntry>> getEntries() async {
    final db = await _db;
    final maps = await db.query(_table, orderBy: 'date DESC');
    return maps.map((map) => SdtEntry.fromMap(map)).toList();
  }

  // New: DB-side filtered fetch
  @override
  Future<List<SdtEntry>> getEntriesFiltered({
    required SdtQueryType type,
    required bool ascending,
    int? limit,
    int? offset,
  }) async {
    final db = await _db;
    final nowIso = DateTime.now().toIso8601String();
    final since = type == SdtQueryType.since;

    final where = since ? 'date <= ?' : 'date > ?';
    final whereArgs = [nowIso];

    final orderBy = 'date ${ascending ? 'ASC' : 'DESC'}';

    final maps = await db.query(
      _table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return maps.map((m) => SdtEntry.fromMap(m)).toList();
  }

  @override
  Future<void> updateEntry(SdtEntry entry) async {
    final db = await _db;
    await db.update(
      _table,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }
}
