import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

import '/db.dart';

//Singlton
class LogManager {
  static final LogManager _instance = LogManager._internal();

  LogMessageDatabase? _db;
  final _log = Logger('$LogManager');
  StreamSubscription<LogRecord>? _sub;

  //This class requires you call the connect() method before using any other functionality
  factory LogManager() {
    return _instance;
  }

  LogManager.testing(LogMessageDatabase db) {
    _db = db;
  }

  LogManager._internal();

  //Connects to the sqlite database passed to the function. Make sure to keep track of where your db is stored as
  //this method doesnt save its location.
  void connect(File file) {
    _db = LogMessageDatabase(file);
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

  Future<void> addLog(LogRecord log) => _getDBInstance().addLog(
        log.time.millisecondsSinceEpoch,
        log.loggerName,
        log.message,
        log.level.value,
        log.error != null ? log.error.toString() : '',
        log.stackTrace != null ? log.stackTrace.toString() : '',
      );

  Future<void> deleteAllLogs() => _getDBInstance().deleteAllLogs();

  Future<void> deleteLogsBefore(DateTime time) =>
      _getDBInstance().deleteBefore(time.millisecondsSinceEpoch);

  Future<List<LogMessage>> getAllLogs({bool reversed = false}) =>
      _getDBInstance().getAllLogs(reversed);

  LogMessageDatabase _getDBInstance() {
    return _db == null ? throw DatabaseConnectionException() : _db!;
  }

  Future<List<LogMessage>> getLogById(int id, {bool reversed = false}) =>
      _getDBInstance().getLogById(id, reversed);

  //This returns null if you pass it an empty string
  Future<List<LogMessage>>? getLogWhereMessageContains(String s,
          {bool reversed = false}) =>
      s.isNotEmpty
          ? _getDBInstance().getLogWhereMessageContains(s, reversed)
          : null;

  Future<List<LogMessage>> getLogsAfter(DateTime dateTime,
          {bool reversed = false}) =>
      _getDBInstance().getLogsAfter(dateTime.millisecondsSinceEpoch, reversed);

  Future<List<LogMessage>> getLogsBefore(DateTime dateTime,
          {bool reversed = false}) =>
      _getDBInstance().getLogsBefore(dateTime.millisecondsSinceEpoch, reversed);

  Future<List<LogMessage>> getLogsByLevel(Level level,
          {bool reversed = false}) =>
      _getDBInstance().getLogsByLevel(level.value, reversed);

  Future<List<LogMessage>> getLogsByName(String name,
          {bool reversed = false}) =>
      _getDBInstance().getLogsByName(name, reversed);

  Future<List<LogMessage>> getLogsNameContains(String s,
          {bool reversed = false}) =>
      _getDBInstance().getLogsNameContains(s, reversed);

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
