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

  Future<List<LogMessage>> getAllLogs(bool reversed) => (select(logMessageTable)
        ..orderBy([
          (t) => OrderingTerm(
              expression: t.id,
              mode: reversed ? OrderingMode.desc : OrderingMode.asc)
        ]))
      .get();

  Future<List<LogMessage>> getLogById(int id, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.id.equals(id))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogsByName(String name, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.name.equals(name))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogsNameContains(String name, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.name.contains(name))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogsByLevel(int level, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.level.equals(level))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogsBefore(int time, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.time.isSmallerThanValue(time))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogsAfter(int time, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.time.isBiggerThanValue(time))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

  Future<List<LogMessage>> getLogWhereMessageContains(
          String s, bool reversed) =>
      (select(logMessageTable)
            ..where((tbl) => tbl.message.contains(s))
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.id,
                  mode: reversed ? OrderingMode.desc : OrderingMode.asc)
            ]))
          .get();

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
