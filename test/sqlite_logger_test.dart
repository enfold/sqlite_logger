import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

import 'package:sqlite_logger/db.dart';
import 'package:sqlite_logger/sqlite_logger.dart';
import 'package:moor/ffi.dart';

void main() {
  late LogMessageDatabase db;

  setUp(() {
    db = LogMessageDatabase.testing(VmDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('logManager exceptions', () {
    final logManager = LogManager();
    Object? result;
    try {
      logManager.getAllLogs();
    } catch (e) {
      result = e;
    }
    expect(result is DatabaseConnectionException, true);
  });

  test('listen test', () async {
    Logger.root.level = Level.ALL;
    const logName = 'Testing';
    const message = 'Test of listener';
    final logManger = LogManager.testing(db);
    final logger = Logger(logName);
    logManger.start();
    logger.log(Level.ALL, message);
    final logList = await logManger.getLogsByName(logName);
    final result = logList.where((log) => log.message.compareTo(message) == 0);
    expect(result.length, 1);
  });
  test('Add log to Database', () async {
    const message = 'Dune is the best SciFi Book!';
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await db.addLog(now, 'Name', message, Level.FINE.value, '', '');
    final logList = await db.getLogById(id);
    expect(logList[0].message, message);
  });

  test('Get all logs in Database', () async {
    const message = 'Dune is the best SciFi Book!';
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.addLog(now, 'Name', message, Level.FINE.value, '', '');
    final logList = await db.getAllLogs;
    expect(logList[0].message, message);
  });

  test('Delete all logs in Database', () async {
    await db.deleteAllLogs();
    final result = await db.getAllLogs;
    expect(result.length, 0);
  });

  test('Accessing LogManager after stop()', () {
    final logManager = LogManager();
    logManager.stop();
    Object? result;
    try {
      logManager.getAllLogs();
    } catch (e) {
      result = e;
    }

    expect(result is DatabaseConnectionException, true);
  });
}
