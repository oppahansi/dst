// Package Imports
import 'package:sqflite/sqflite.dart';

// Project Imports
import 'package:sdtpro/core/db/db.dart';
import 'package:sdtpro/features/days_since/domain/entities/ds_entry.dart';
import 'package:sdtpro/features/days_since/domain/repos/days_since_repository.dart';

class DsRepoImpl implements DsRepo {
  static final DsRepoImpl _instance = DsRepoImpl._internal();
  factory DsRepoImpl() => _instance;
  DsRepoImpl._internal();

  static const String _table = 'entries';

  Future<Database> get _db async => Db.getUserDbInstance();

  @override
  Future<DsEntry> addEntry(DsEntry entry) async {
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
  Future<List<DsEntry>> getEntries() async {
    final db = await _db;
    final maps = await db.query(_table, orderBy: 'date DESC');
    return maps.map((map) => DsEntry.fromMap(map)).toList();
  }

  @override
  Future<void> updateEntry(DsEntry entry) async {
    final db = await _db;
    await db.update(
      _table,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }
}
