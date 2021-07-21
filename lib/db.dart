import 'dart:io';

import 'package:logging/logging.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

part 'db.g.dart';

@DataClassName('LogMessage')
class LogMessageTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get time => integer()();
  TextColumn get message => text()();
  IntColumn get level => integer()();
  TextColumn get error => text()();
  TextColumn get stack => text()();
}

@UseMoor(tables: [LogMessageTable])
class LogMessageDatabase extends _$LogMessageDatabase {
  File? dbFile;
  LogMessageDatabase(this.dbFile) : super(_openConnection(dbFile!));
  LogMessageDatabase.testing(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static final _log = Logger("$LogMessageDatabase");

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

  Future<List<LogMessage>> get getAllLogs => select(logMessageTable).get();

  Future<List<LogMessage>> getLogById(int id) =>
      (select(logMessageTable)..where((tbl) => tbl.id.equals(id))).get();

  Future<List<LogMessage>> getLogsByName(String name) =>
      (select(logMessageTable)..where((tbl) => tbl.name.equals(name))).get();

  Future<List<LogMessage>> getLogsNameContains(String name) =>
      (select(logMessageTable)..where((tbl) => tbl.name.contains(name))).get();

  Future<List<LogMessage>> getLogsByLevel(int level) =>
      (select(logMessageTable)..where((tbl) => tbl.level.equals(level))).get();

  Future<List<LogMessage>> getLogsBefore(int time) => (select(logMessageTable)
        ..where((tbl) => tbl.time.isSmallerThanValue(time)))
      .get();

  Future<List<LogMessage>> getLogsAfter(int time) => (select(logMessageTable)
        ..where((tbl) => tbl.time.isBiggerThanValue(time)))
      .get();

  Future<List<LogMessage>> getLogWhereMessageContains(String s) =>
      (select(logMessageTable)..where((tbl) => tbl.message.contains(s))).get();

  Future<int> addLog(int time, String name, String message, int level,
      String error, String stack) {
    var entry = LogMessageTableCompanion.insert(
        time: time,
        name: name,
        message: message,
        level: level,
        error: error,
        stack: stack);
    return into(logMessageTable).insert(entry);
  }

  List<Future<int>> addAllLogs(List<LogMessage> logList) =>
      [for (final log in logList) into(logMessageTable).insert(log)];

  Future<void> deleteBefore(int time) => (delete(logMessageTable)
        ..where((tbl) => tbl.time.isSmallerThanValue(time)))
      .go();

  Future<void> deleteAllLogs() => delete(logMessageTable).go();
}
