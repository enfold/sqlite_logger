import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:moor/ffi.dart';

import '/db.dart';

//Singlton
class LogManager {
  static final LogManager _instance = LogManager._internal();

  late final DBLogRecordDatabase? _db;
  final _log = Logger('$LogManager');
  StreamSubscription<LogRecord>? _sub;

  //This class requires you call the connect() method before using any other functionality
  factory LogManager() {
    return _instance;
  }

  LogManager.testing() {
    _db = DBLogRecordDatabase.testing(VmDatabase.memory());
  }

  LogManager._internal();

  //Connects to the sqlite database passed to the function. Make sure to keep track of where your db is stored as
  //this method doesnt save its location.
  void connect(File file) {
    _db = DBLogRecordDatabase(file);
  }

  //Starts listening to log events saving them to the logs database. Make sure to call connect(file) before listening to logs output.
  //Make sure to call stop() when you're done listening to log events.
  void start() {
    if (_db == null) {
      throw DatabaseConnectionException();
    }
    _sub = Logger.root.onRecord.listen((event) {
      addLog(event);
    });
    _log.info('Logger added Listener');
  }

  //Unsubscribes from the log Stream. Make sure to call when you're dont listening for logs.
  Future<void> stop() async {
    await _sub?.cancel();
  }

  Future<void> addLog(LogRecord log) => _db != null
      ? _db!.addLog(
          log.time.millisecondsSinceEpoch,
          log.loggerName,
          log.message,
          log.level.value,
          log.error != null ? log.error.toString() : '',
          log.stackTrace != null ? log.stackTrace.toString() : '',
        )
      : throw DatabaseConnectionException();

  Future<void> deleteAllLogs() =>
      _db == null ? throw DatabaseConnectionException() : _db!.deleteAllLogs();

  Future<void> deleteLogsBefore(DateTime time) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.deleteBefore(time.millisecondsSinceEpoch);

  Future<List<DBLogRecord>> getAllLogs() =>
      _db == null ? throw DatabaseConnectionException() : _db!.getAllLogs;

  Future<List<DBLogRecord>> getLogById(int id) =>
      _db == null ? throw DatabaseConnectionException() : _db!.getLogById(id);

  //This returns null if you pass it an empty string
  Future<List<DBLogRecord>>? getLogWhereMessageContains(String s) => _db == null
      ? throw DatabaseConnectionException()
      : s.isNotEmpty
          ? _db!.getLogWhereMessageContains(s)
          : null;

  Future<List<DBLogRecord>> getLogsAfter(DateTime dateTime) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.getLogsAfter(dateTime.millisecondsSinceEpoch);

  Future<List<DBLogRecord>> getLogsBefore(DateTime dateTime) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.getLogsBefore(dateTime.millisecondsSinceEpoch);

  Future<List<DBLogRecord>> getLogsByLevel(Level level) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.getLogsByLevel(level.value);

  Future<List<DBLogRecord>> getLogsByName(String name) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.getLogsByName(name);

  Future<List<DBLogRecord>> getLogsNameContains(String s) => _db == null
      ? throw DatabaseConnectionException()
      : _db!.getLogsNameContains(s);

  Future<void> truncateLogs(Duration duration) {
    if (_db == null) {
      throw DatabaseConnectionException();
    }
    final now = DateTime.now();
    return _db!.deleteBefore(now.subtract(duration).millisecondsSinceEpoch);
  }
}

class DatabaseConnectionException implements Exception {
  final message = 'Make sure to call connect() before using this LogManager';
  DatabaseConnectionException();
}
