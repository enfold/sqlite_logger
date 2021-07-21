// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LogMessage extends DataClass implements Insertable<LogMessage> {
  final int id;
  final String name;
  final int time;
  final String message;
  final int level;
  final String error;
  final String stack;
  LogMessage(
      {required this.id,
      required this.name,
      required this.time,
      required this.message,
      required this.level,
      required this.error,
      required this.stack});
  factory LogMessage.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return LogMessage(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      message: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}message'])!,
      level: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}level'])!,
      error: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}error'])!,
      stack: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stack'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['time'] = Variable<int>(time);
    map['message'] = Variable<String>(message);
    map['level'] = Variable<int>(level);
    map['error'] = Variable<String>(error);
    map['stack'] = Variable<String>(stack);
    return map;
  }

  LogMessageTableCompanion toCompanion(bool nullToAbsent) {
    return LogMessageTableCompanion(
      id: Value(id),
      name: Value(name),
      time: Value(time),
      message: Value(message),
      level: Value(level),
      error: Value(error),
      stack: Value(stack),
    );
  }

  factory LogMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LogMessage(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      time: serializer.fromJson<int>(json['time']),
      message: serializer.fromJson<String>(json['message']),
      level: serializer.fromJson<int>(json['level']),
      error: serializer.fromJson<String>(json['error']),
      stack: serializer.fromJson<String>(json['stack']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'time': serializer.toJson<int>(time),
      'message': serializer.toJson<String>(message),
      'level': serializer.toJson<int>(level),
      'error': serializer.toJson<String>(error),
      'stack': serializer.toJson<String>(stack),
    };
  }

  LogMessage copyWith(
          {int? id,
          String? name,
          int? time,
          String? message,
          int? level,
          String? error,
          String? stack}) =>
      LogMessage(
        id: id ?? this.id,
        name: name ?? this.name,
        time: time ?? this.time,
        message: message ?? this.message,
        level: level ?? this.level,
        error: error ?? this.error,
        stack: stack ?? this.stack,
      );
  @override
  String toString() {
    return (StringBuffer('LogMessage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('time: $time, ')
          ..write('message: $message, ')
          ..write('level: $level, ')
          ..write('error: $error, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              time.hashCode,
              $mrjc(
                  message.hashCode,
                  $mrjc(level.hashCode,
                      $mrjc(error.hashCode, stack.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogMessage &&
          other.id == this.id &&
          other.name == this.name &&
          other.time == this.time &&
          other.message == this.message &&
          other.level == this.level &&
          other.error == this.error &&
          other.stack == this.stack);
}

class LogMessageTableCompanion extends UpdateCompanion<LogMessage> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> time;
  final Value<String> message;
  final Value<int> level;
  final Value<String> error;
  final Value<String> stack;
  const LogMessageTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.time = const Value.absent(),
    this.message = const Value.absent(),
    this.level = const Value.absent(),
    this.error = const Value.absent(),
    this.stack = const Value.absent(),
  });
  LogMessageTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int time,
    required String message,
    required int level,
    required String error,
    required String stack,
  })  : name = Value(name),
        time = Value(time),
        message = Value(message),
        level = Value(level),
        error = Value(error),
        stack = Value(stack);
  static Insertable<LogMessage> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? time,
    Expression<String>? message,
    Expression<int>? level,
    Expression<String>? error,
    Expression<String>? stack,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (time != null) 'time': time,
      if (message != null) 'message': message,
      if (level != null) 'level': level,
      if (error != null) 'error': error,
      if (stack != null) 'stack': stack,
    });
  }

  LogMessageTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? time,
      Value<String>? message,
      Value<int>? level,
      Value<String>? error,
      Value<String>? stack}) {
    return LogMessageTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      message: message ?? this.message,
      level: level ?? this.level,
      error: error ?? this.error,
      stack: stack ?? this.stack,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (stack.present) {
      map['stack'] = Variable<String>(stack.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogMessageTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('time: $time, ')
          ..write('message: $message, ')
          ..write('level: $level, ')
          ..write('error: $error, ')
          ..write('stack: $stack')
          ..write(')'))
        .toString();
  }
}

class $LogMessageTableTable extends LogMessageTable
    with TableInfo<$LogMessageTableTable, LogMessage> {
  final GeneratedDatabase _db;
  final String? _alias;
  $LogMessageTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _messageMeta = const VerificationMeta('message');
  late final GeneratedColumn<String?> message = GeneratedColumn<String?>(
      'message', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _levelMeta = const VerificationMeta('level');
  late final GeneratedColumn<int?> level = GeneratedColumn<int?>(
      'level', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _errorMeta = const VerificationMeta('error');
  late final GeneratedColumn<String?> error = GeneratedColumn<String?>(
      'error', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _stackMeta = const VerificationMeta('stack');
  late final GeneratedColumn<String?> stack = GeneratedColumn<String?>(
      'stack', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, time, message, level, error, stack];
  @override
  String get aliasedName => _alias ?? 'log_message_table';
  @override
  String get actualTableName => 'log_message_table';
  @override
  VerificationContext validateIntegrity(Insertable<LogMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    } else if (isInserting) {
      context.missing(_errorMeta);
    }
    if (data.containsKey('stack')) {
      context.handle(
          _stackMeta, stack.isAcceptableOrUnknown(data['stack']!, _stackMeta));
    } else if (isInserting) {
      context.missing(_stackMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    return LogMessage.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LogMessageTableTable createAlias(String alias) {
    return $LogMessageTableTable(_db, alias);
  }
}

abstract class _$LogMessageDatabase extends GeneratedDatabase {
  _$LogMessageDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final $LogMessageTableTable logMessageTable =
      $LogMessageTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [logMessageTable];
}
