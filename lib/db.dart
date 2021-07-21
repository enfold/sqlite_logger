import 'dart:io';

import 'package:logging/logging.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

part 'db.g.dart';

@DataClassName('DBLogRecord')
class DBLogRecordTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get time => integer()();
  TextColumn get message => text()();
  IntColumn get level => integer()();
  TextColumn get error => text()();
  TextColumn get stack => text()();
}

@UseMoor(tables: [DBLogRecordTable])
class DBLogRecordDatabase extends _$DBLogRecordDatabase {
  File? dbFile;
  DBLogRecordDatabase(this.dbFile) : super(_openConnection(dbFile!));
  DBLogRecordDatabase.testing(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static final _log = Logger("$DBLogRecordDatabase");

  static LazyDatabase _openConnection(File file) {
    return LazyDatabase(() async {
      return _initDb(file);
    });
  }

  static VmDatabase _initDb(File file) => VmDatabase(file, setup: (db) {
        db.execute('PRAGMA sync = false');
        db.execute('PRAGMA journal_mode = WAL');
        _log.fine('executed PRAGMA statements');
      });

  Future<List<DBLogRecord>> get getAllLogs => select(dBLogRecordTable).get();

  Future<List<DBLogRecord>> getLogById(int id) =>
      (select(dBLogRecordTable)..where((tbl) => tbl.id.equals(id))).get();

  Future<List<DBLogRecord>> getLogsByName(String name) =>
      (select(dBLogRecordTable)..where((tbl) => tbl.name.equals(name))).get();

  Future<List<DBLogRecord>> getLogsNameContains(String name) =>
      (select(dBLogRecordTable)..where((tbl) => tbl.name.contains(name))).get();

  Future<List<DBLogRecord>> getLogsByLevel(int level) =>
      (select(dBLogRecordTable)..where((tbl) => tbl.level.equals(level))).get();

  Future<List<DBLogRecord>> getLogsBefore(int time) => (select(dBLogRecordTable)
        ..where((tbl) => tbl.time.isSmallerThanValue(time)))
      .get();

  Future<List<DBLogRecord>> getLogsAfter(int time) => (select(dBLogRecordTable)
        ..where((tbl) => tbl.time.isBiggerThanValue(time)))
      .get();

  Future<List<DBLogRecord>> getLogWhereMessageContains(String s) =>
      (select(dBLogRecordTable)..where((tbl) => tbl.message.contains(s))).get();

  Future<int> addLog(int time, String name, String message, int level,
      String error, String stack) {
    var entry = DBLogRecordTableCompanion.insert(
        time: time,
        name: name,
        message: message,
        level: level,
        error: error,
        stack: stack);
    return into(dBLogRecordTable).insert(entry);
  }

  List<Future<int>> addAllLogs(List<DBLogRecord> logList) =>
      [for (final log in logList) into(dBLogRecordTable).insert(log)];

  Future<void> deleteBefore(int time) => (delete(dBLogRecordTable)
        ..where((tbl) => tbl.time.isSmallerThanValue(time)))
      .go();

  Future<void> deleteAllLogs() => delete(dBLogRecordTable).go();
}
