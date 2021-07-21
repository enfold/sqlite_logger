# sqlite_logger

A Flutter package for saving all your logs to a database and view them in a Widget.

## Overview

This package provides an API for saving logs created using the [logging](https://pub.dev/packages/logging) plugin
to a splite database created and managed using [moor](https://pub.dev/packages/moor). It 
also provides a Widget name LogViewer for viewing the logs from within your app.

### Dependencies 

* [moor: ^4.4.1](https://pub.dev/packages/moor)
* [logging: ^1.0.1](https://pub.dev/packages/logging)
* [sqlite3_flutter_libs: ^0.5.0](https://pub.dev/packages/sqlite3_flutter_libs)
* [flutter_spinkit: ^5.0.0](https://pub.dev/packages/flutter_spinkit)
* [pull_to_refresh: ^2.0.0](https://pub.dev/packages/pull_to_refresh)

### Dev Dependencies 

* [moor_generator](https://pub.dev/packages/moor_generator)
* [build_runner](https://pub.dev/packages/build_runner)


## Getting Started

First of all add this package as a dependency by adding this to your pubspec.yaml file

```yaml
dependencies:
    sqlite_logger: {$github_path}
```

Now we can use the LogManger. If you havent already created a .sqlite file to hold the 
database do that now. Make sure to keep track of the database path as this package doesnt.

Example:

```dart
File file;

@override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) => initFile(value));
  }

  void initFile(Directory dir) async {
    file = await File(p.join(dir.path, 'db.splite')).create();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logging_db_path', file.path);
  }
```

Once you've created the database file we can connect to the database file and start
listening for logEvents. Make sure to call connect(file) before calling start() to begin 
listening for log events. If you dont this will throw a DatabaseConnectionException.
Make sure to set the logger level so all the proper logs are saves to the database.

Example:
```dart
@override
void initState(){
Logger.root.level = Level.ALL;
final logManager = LogManager();
//Connect to the database file created in the above example.
logManager.connect(file);
//Call start to begin listening for logEvents and save them to the database.
logManager.start();
}

 @override
  void dispose() {
    //Stop listening for logs whenever makes sense in your applicaiton.
    logManager.stop();
    super.dispose();
  }

```

There are a number of ways to view and access the logs saves to the sqlite database. One is 
to simply query the database usng the same logManager that was used above. LogManager comes
with a number of query methods. Keep in mind when querying that the data returned is sorted 
by database id so you must sort the List yourself if you're looking for anything else.

Example:

```dart
//Get all the logs in the database.
final logList = await logManager.getAllLogs();
//Sort all the logs returned from newest to oldest.
logList.sort((a, b) => b.time.compareTo(a.time))
```

If you want to show the logs to the user we provide a Widget that creates a ListView of logs
for you. All you pass in is the logManager you created earlier.

Example:

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: logManger != null
              ? LogViewer(logManger!)
              : const Text('DB not init')),
    );
  }
```

## TODO 
 The horizon is full of possibilities 

- Launch DB in a seperate isolate

- Add coby log button 
- Add a search bar
- Add a filter list by option
- trace formatter

Trevor - Feature Idea - 
- export the logging database as JSON so it could be saved serverside.

Alan testing advice.

  - test/sqlite_logger_test.dart

    - I do not see a test of exceptions / stacktrace

    - I dont see a failure case of catching exception if you attempt to grab the LogManager

      by the wrong end (note you have a lot of exceptions being thrown)

    - I would expect the following tests:

      - Attempting to use the LogManager without initializing

      - Attempting to use the LogManager after cancel but did not connect

      - Whatever dispose client logic is needed
