import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:logging/logging.dart';

import '/logs_db.dart';
import '/db.dart';

//Widget for viewing logs stored in the passed log database file.
class LogViewer extends StatefulWidget {
  final LogManager _logManager;

  const LogViewer(this._logManager, {Key? key}) : super(key: key);

  @override
  _LogViewerState createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  late final LogManager _logManager;
  final _controller = RefreshController(initialRefresh: false);
  var _logs = <Log>[];
  final levelReverseMap = {
    for (final level in Level.LEVELS) level.value: level.name
  };

  @override
  void initState() {
    super.initState();
    _logManager = widget._logManager;
    _logManager.getAllLogs().then((value) => _setLogState(value));
  }

  void _setLogState(List<Log> logState) {
    logState.sort((a, b) => b.time.compareTo(a.time));
    setState(() {
      _logs = logState;
    });
  }

  void refreshLogState() {
    _logManager.getAllLogs().then((value) {
      _setLogState(value);
      _controller.refreshCompleted();
    });
  }

  String dateFormatter(DateTime date) {
    return '${date.hour}:${date.minute}:${date.second} ${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return _logs.isNotEmpty
        ? logList(context)
        : const SpinKitRotatingCircle(color: Colors.blue, size: 40.0);
  }

  Widget logList(BuildContext context) {
    return SmartRefresher(
      controller: _controller,
      enablePullDown: true,
      onRefresh: refreshLogState,
      child:
          ListView.builder(itemCount: _logs.length, itemBuilder: _buildLogTile),
    );
  }

  Widget lineItem(String title, String value) {
    const itemPadding = EdgeInsets.all(2);
    return Row(
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
          padding: itemPadding,
        )
      ],
    );
  }

  Widget _buildLogTile(BuildContext context, int index) {
    final _log = _logs[index];
    const itemPadding = EdgeInsets.all(2);
    return Card(
        child: Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lineItem('Name: ', _log.name),
          lineItem('Time: ',
              dateFormatter(DateTime.fromMillisecondsSinceEpoch(_log.time))),
          lineItem('Level: ', levelReverseMap[_log.level]!),
          lineItem('Message: ', _log.message),
          lineItem('Error: ', _log.error.isEmpty ? 'No' : 'Yes'),
        ],
      ),
      Expanded(
          child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: itemPadding,
            child: TextButton(
                onPressed: () => expandLog(index),
                child: const Icon(Icons.more_horiz))),
      ))
    ]));
  }

  void expandLog(int index) async {
    final _log = _logs[index];
    final width = MediaQuery.of(context).size.width;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(_log.name),
            titlePadding: const EdgeInsets.all(8),
            insetPadding: const EdgeInsets.all(4),
            children: [
              Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    children: [
                      SizedBox(
                          width: width - width / 5,
                          child: lineItem(
                              'Time: ',
                              DateTime.fromMillisecondsSinceEpoch(_log.time)
                                  .toIso8601String())),
                      SizedBox(
                          width: width - width / 5,
                          child: lineItem(
                              'Level: ', levelReverseMap[_log.level]!)),
                      SizedBox(
                          width: width - width / 5,
                          child: lineItem('Message: ', _log.message)),
                      SizedBox(
                          width: width - width / 5,
                          child: lineItem('Error: ', _log.error)),
                      SizedBox(
                          width: width - width / 5,
                          child: lineItem('StackTrace: ', _log.stack)),
                    ],
                  ))
            ],
          );
        });
  }
}
