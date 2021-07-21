import 'dart:io';

import 'package:logging/logging.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

part 'db.g.dart';

@DataClassName('Log')
class LogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get time => integer()();
  TextColumn get message => text()();
  IntColumn get level => integer()();
  TextColumn get error => text()();
  TextColumn get stack => text()();
}

@UseMoor(tables: [LogTable])
class LogDatabase extends _$LogDatabase {
  File? dbFile;
  LogDatabase(this.dbFile) : super(_openConnection(dbFile!));
  LogDatabase.testing(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static final _log = Logger("$LogDatabase");

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

  Future<List<Log>> get getAllLogs => select(logTable).get();

  Future<List<Log>> getLogById(int id) =>
      (select(logTable)..where((tbl) => tbl.id.equals(id))).get();

  Future<List<Log>> getLogsByName(String name) =>
      (select(logTable)..where((tbl) => tbl.name.equals(name))).get();

  Future<List<Log>> getLogsNameContains(String name) =>
      (select(logTable)..where((tbl) => tbl.name.contains(name))).get();

  Future<List<Log>> getLogsByLevel(int level) =>
      (select(logTable)..where((tbl) => tbl.level.equals(level))).get();

  Future<List<Log>> getLogsBefore(int time) =>
      (select(logTable)..where((tbl) => tbl.time.isSmallerThanValue(time)))
          .get();

  Future<List<Log>> getLogsAfter(int time) =>
      (select(logTable)..where((tbl) => tbl.time.isBiggerThanValue(time)))
          .get();

  Future<List<Log>> getLogWhereMessageContains(String s) =>
      (select(logTable)..where((tbl) => tbl.message.contains(s))).get();

  Future<int> addLog(int time, String name, String message, int level,
      String error, String stack) {
    var entry = LogTableCompanion.insert(
        time: time,
        name: name,
        message: message,
        level: level,
        error: error,
        stack: stack);
    return into(logTable).insert(entry);
  }

  List<Future<int>> addAllLogs(List<Log> logList) =>
      [for (final log in logList) into(logTable).insert(log)];

  Future<void> deleteBefore(int time) =>
      (delete(logTable)..where((tbl) => tbl.time.isSmallerThanValue(time)))
          .go();

  Future<void> deleteAllLogs() => delete(logTable).go();
}
