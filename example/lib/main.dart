import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sqlite_logger/sqlite_logger.dart';
import 'package:sqlite_logger/widgets/log_viewer.dart';

import '/randon_log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LogManager? logManger;
  late File dbFile;
  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    getApplicationDocumentsDirectory().then((value) => initFile(value));
  }

  void initFile(Directory dir) {
    File(p.join(dir.path, 'db.splite')).create().then((value) => initDB(value));
  }

  void initDB(File file) {
    dbFile = file;
    setState(() {
      logManger = LogManager();
      logManger!.connect(file);
      logManger!.start();
    });
  }

  void addLog() {
    RandomLogGenerator.create();
  }

  @override
  void dispose() {
    logManger?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: logManger != null
              ? LogViewer(logManger!)
              : const SpinKitRotatingCircle(
                  color: Colors.blue,
                )),
      floatingActionButton: FloatingActionButton(onPressed: addLog),
    );
  }
}
