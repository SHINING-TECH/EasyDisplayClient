// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _securityQuestionMeta =
      const VerificationMeta('securityQuestion');
  @override
  late final GeneratedColumn<String> securityQuestion = GeneratedColumn<String>(
      'security_question', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _securityAnswerMeta =
      const VerificationMeta('securityAnswer');
  @override
  late final GeneratedColumn<String> securityAnswer = GeneratedColumn<String>(
      'security_answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        password,
        securityQuestion,
        securityAnswer,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('security_question')) {
      context.handle(
          _securityQuestionMeta,
          securityQuestion.isAcceptableOrUnknown(
              data['security_question']!, _securityQuestionMeta));
    }
    if (data.containsKey('security_answer')) {
      context.handle(
          _securityAnswerMeta,
          securityAnswer.isAcceptableOrUnknown(
              data['security_answer']!, _securityAnswerMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      securityQuestion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}security_question']),
      securityAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}security_answer']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String password;
  final String? securityQuestion;
  final String? securityAnswer;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      required this.password,
      this.securityQuestion,
      this.securityAnswer,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || securityQuestion != null) {
      map['security_question'] = Variable<String>(securityQuestion);
    }
    if (!nullToAbsent || securityAnswer != null) {
      map['security_answer'] = Variable<String>(securityAnswer);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      securityQuestion: securityQuestion == null && nullToAbsent
          ? const Value.absent()
          : Value(securityQuestion),
      securityAnswer: securityAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(securityAnswer),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      securityQuestion: serializer.fromJson<String?>(json['securityQuestion']),
      securityAnswer: serializer.fromJson<String?>(json['securityAnswer']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'securityQuestion': serializer.toJson<String?>(securityQuestion),
      'securityAnswer': serializer.toJson<String?>(securityAnswer),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? password,
          Value<String?> securityQuestion = const Value.absent(),
          Value<String?> securityAnswer = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        securityQuestion: securityQuestion.present
            ? securityQuestion.value
            : this.securityQuestion,
        securityAnswer:
            securityAnswer.present ? securityAnswer.value : this.securityAnswer,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      securityQuestion: data.securityQuestion.present
          ? data.securityQuestion.value
          : this.securityQuestion,
      securityAnswer: data.securityAnswer.present
          ? data.securityAnswer.value
          : this.securityAnswer,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('securityQuestion: $securityQuestion, ')
          ..write('securityAnswer: $securityAnswer, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, password, securityQuestion,
      securityAnswer, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.securityQuestion == this.securityQuestion &&
          other.securityAnswer == this.securityAnswer &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String?> securityQuestion;
  final Value<String?> securityAnswer;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.securityQuestion = const Value.absent(),
    this.securityAnswer = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    this.securityQuestion = const Value.absent(),
    this.securityAnswer = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? securityQuestion,
    Expression<String>? securityAnswer,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (securityQuestion != null) 'security_question': securityQuestion,
      if (securityAnswer != null) 'security_answer': securityAnswer,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<String?>? securityQuestion,
      Value<String?>? securityAnswer,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      securityQuestion: securityQuestion ?? this.securityQuestion,
      securityAnswer: securityAnswer ?? this.securityAnswer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (securityQuestion.present) {
      map['security_question'] = Variable<String>(securityQuestion.value);
    }
    if (securityAnswer.present) {
      map['security_answer'] = Variable<String>(securityAnswer.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('securityQuestion: $securityQuestion, ')
          ..write('securityAnswer: $securityAnswer, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TemplatesGroupTable extends TemplatesGroup
    with TableInfo<$TemplatesGroupTable, TemplatesGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesGroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fatherIdMeta =
      const VerificationMeta('fatherId');
  @override
  late final GeneratedColumn<int> fatherId = GeneratedColumn<int>(
      'father_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, fatherId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates_group';
  @override
  VerificationContext validateIntegrity(Insertable<TemplatesGroupData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('father_id')) {
      context.handle(_fatherIdMeta,
          fatherId.isAcceptableOrUnknown(data['father_id']!, _fatherIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplatesGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplatesGroupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      fatherId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}father_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TemplatesGroupTable createAlias(String alias) {
    return $TemplatesGroupTable(attachedDatabase, alias);
  }
}

class TemplatesGroupData extends DataClass
    implements Insertable<TemplatesGroupData> {
  final int id;
  final String label;
  final int? fatherId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TemplatesGroupData(
      {required this.id,
      required this.label,
      this.fatherId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || fatherId != null) {
      map['father_id'] = Variable<int>(fatherId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TemplatesGroupCompanion toCompanion(bool nullToAbsent) {
    return TemplatesGroupCompanion(
      id: Value(id),
      label: Value(label),
      fatherId: fatherId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TemplatesGroupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplatesGroupData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      fatherId: serializer.fromJson<int?>(json['fatherId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'fatherId': serializer.toJson<int?>(fatherId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TemplatesGroupData copyWith(
          {int? id,
          String? label,
          Value<int?> fatherId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TemplatesGroupData(
        id: id ?? this.id,
        label: label ?? this.label,
        fatherId: fatherId.present ? fatherId.value : this.fatherId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TemplatesGroupData copyWithCompanion(TemplatesGroupCompanion data) {
    return TemplatesGroupData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      fatherId: data.fatherId.present ? data.fatherId.value : this.fatherId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesGroupData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, fatherId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplatesGroupData &&
          other.id == this.id &&
          other.label == this.label &&
          other.fatherId == this.fatherId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TemplatesGroupCompanion extends UpdateCompanion<TemplatesGroupData> {
  final Value<int> id;
  final Value<String> label;
  final Value<int?> fatherId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TemplatesGroupCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TemplatesGroupCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : label = Value(label);
  static Insertable<TemplatesGroupData> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? fatherId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (fatherId != null) 'father_id': fatherId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TemplatesGroupCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<int?>? fatherId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TemplatesGroupCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      fatherId: fatherId ?? this.fatherId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (fatherId.present) {
      map['father_id'] = Variable<int>(fatherId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesGroupCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ResourceTypeTable extends ResourceType
    with TableInfo<$ResourceTypeTable, ResourceTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResourceTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, type, label, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resource_type';
  @override
  VerificationContext validateIntegrity(Insertable<ResourceTypeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResourceTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResourceTypeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ResourceTypeTable createAlias(String alias) {
    return $ResourceTypeTable(attachedDatabase, alias);
  }
}

class ResourceTypeData extends DataClass
    implements Insertable<ResourceTypeData> {
  final int id;
  final String type;
  final String label;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ResourceTypeData(
      {required this.id,
      required this.type,
      required this.label,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ResourceTypeCompanion toCompanion(bool nullToAbsent) {
    return ResourceTypeCompanion(
      id: Value(id),
      type: Value(type),
      label: Value(label),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ResourceTypeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResourceTypeData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ResourceTypeData copyWith(
          {int? id,
          String? type,
          String? label,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ResourceTypeData(
        id: id ?? this.id,
        type: type ?? this.type,
        label: label ?? this.label,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ResourceTypeData copyWithCompanion(ResourceTypeCompanion data) {
    return ResourceTypeData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResourceTypeData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, label, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResourceTypeData &&
          other.id == this.id &&
          other.type == this.type &&
          other.label == this.label &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ResourceTypeCompanion extends UpdateCompanion<ResourceTypeData> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ResourceTypeCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ResourceTypeCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String label,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : type = Value(type),
        label = Value(label);
  static Insertable<ResourceTypeData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ResourceTypeCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? label,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ResourceTypeCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResourceTypeCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ResourceGroupTable extends ResourceGroup
    with TableInfo<$ResourceGroupTable, ResourceGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResourceGroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _groupNameMeta =
      const VerificationMeta('groupName');
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
      'group_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, groupName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resource_group';
  @override
  VerificationContext validateIntegrity(Insertable<ResourceGroupData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(_groupNameMeta,
          groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta));
    } else if (isInserting) {
      context.missing(_groupNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResourceGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResourceGroupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      groupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ResourceGroupTable createAlias(String alias) {
    return $ResourceGroupTable(attachedDatabase, alias);
  }
}

class ResourceGroupData extends DataClass
    implements Insertable<ResourceGroupData> {
  final int id;
  final String type;
  final String groupName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ResourceGroupData(
      {required this.id,
      required this.type,
      required this.groupName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['group_name'] = Variable<String>(groupName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ResourceGroupCompanion toCompanion(bool nullToAbsent) {
    return ResourceGroupCompanion(
      id: Value(id),
      type: Value(type),
      groupName: Value(groupName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ResourceGroupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResourceGroupData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      groupName: serializer.fromJson<String>(json['groupName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'groupName': serializer.toJson<String>(groupName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ResourceGroupData copyWith(
          {int? id,
          String? type,
          String? groupName,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ResourceGroupData(
        id: id ?? this.id,
        type: type ?? this.type,
        groupName: groupName ?? this.groupName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ResourceGroupData copyWithCompanion(ResourceGroupCompanion data) {
    return ResourceGroupData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResourceGroupData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, groupName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResourceGroupData &&
          other.id == this.id &&
          other.type == this.type &&
          other.groupName == this.groupName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ResourceGroupCompanion extends UpdateCompanion<ResourceGroupData> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> groupName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ResourceGroupCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.groupName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ResourceGroupCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String groupName,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : type = Value(type),
        groupName = Value(groupName);
  static Insertable<ResourceGroupData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? groupName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (groupName != null) 'group_name': groupName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ResourceGroupCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? groupName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ResourceGroupCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResourceGroupCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ResourceTable extends Resource
    with TableInfo<$ResourceTable, ResourceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResourceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _thumbnailMeta =
      const VerificationMeta('thumbnail');
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
      'thumbnail', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _showFileSizeMeta =
      const VerificationMeta('showFileSize');
  @override
  late final GeneratedColumn<String> showFileSize = GeneratedColumn<String>(
      'show_file_size', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _localFilePathMeta =
      const VerificationMeta('localFilePath');
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
      'local_file_path', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        type,
        name,
        url,
        thumbnail,
        fileSize,
        showFileSize,
        localFilePath,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resource';
  @override
  VerificationContext validateIntegrity(Insertable<ResourceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('thumbnail')) {
      context.handle(_thumbnailMeta,
          thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta));
    } else if (isInserting) {
      context.missing(_thumbnailMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    }
    if (data.containsKey('show_file_size')) {
      context.handle(
          _showFileSizeMeta,
          showFileSize.isAcceptableOrUnknown(
              data['show_file_size']!, _showFileSizeMeta));
    } else if (isInserting) {
      context.missing(_showFileSizeMeta);
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
          _localFilePathMeta,
          localFilePath.isAcceptableOrUnknown(
              data['local_file_path']!, _localFilePathMeta));
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResourceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResourceData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      thumbnail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      showFileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}show_file_size'])!,
      localFilePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_file_path'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ResourceTable createAlias(String alias) {
    return $ResourceTable(attachedDatabase, alias);
  }
}

class ResourceData extends DataClass implements Insertable<ResourceData> {
  final int id;
  final int? groupId;
  final String type;
  final String name;
  final String url;
  final String thumbnail;
  final int fileSize;
  final String showFileSize;
  final String localFilePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ResourceData(
      {required this.id,
      this.groupId,
      required this.type,
      required this.name,
      required this.url,
      required this.thumbnail,
      required this.fileSize,
      required this.showFileSize,
      required this.localFilePath,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['thumbnail'] = Variable<String>(thumbnail);
    map['file_size'] = Variable<int>(fileSize);
    map['show_file_size'] = Variable<String>(showFileSize);
    map['local_file_path'] = Variable<String>(localFilePath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ResourceCompanion toCompanion(bool nullToAbsent) {
    return ResourceCompanion(
      id: Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      type: Value(type),
      name: Value(name),
      url: Value(url),
      thumbnail: Value(thumbnail),
      fileSize: Value(fileSize),
      showFileSize: Value(showFileSize),
      localFilePath: Value(localFilePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ResourceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResourceData(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      showFileSize: serializer.fromJson<String>(json['showFileSize']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int?>(groupId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'fileSize': serializer.toJson<int>(fileSize),
      'showFileSize': serializer.toJson<String>(showFileSize),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ResourceData copyWith(
          {int? id,
          Value<int?> groupId = const Value.absent(),
          String? type,
          String? name,
          String? url,
          String? thumbnail,
          int? fileSize,
          String? showFileSize,
          String? localFilePath,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ResourceData(
        id: id ?? this.id,
        groupId: groupId.present ? groupId.value : this.groupId,
        type: type ?? this.type,
        name: name ?? this.name,
        url: url ?? this.url,
        thumbnail: thumbnail ?? this.thumbnail,
        fileSize: fileSize ?? this.fileSize,
        showFileSize: showFileSize ?? this.showFileSize,
        localFilePath: localFilePath ?? this.localFilePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ResourceData copyWithCompanion(ResourceCompanion data) {
    return ResourceData(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      showFileSize: data.showFileSize.present
          ? data.showFileSize.value
          : this.showFileSize,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResourceData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('fileSize: $fileSize, ')
          ..write('showFileSize: $showFileSize, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, type, name, url, thumbnail,
      fileSize, showFileSize, localFilePath, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResourceData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.type == this.type &&
          other.name == this.name &&
          other.url == this.url &&
          other.thumbnail == this.thumbnail &&
          other.fileSize == this.fileSize &&
          other.showFileSize == this.showFileSize &&
          other.localFilePath == this.localFilePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ResourceCompanion extends UpdateCompanion<ResourceData> {
  final Value<int> id;
  final Value<int?> groupId;
  final Value<String> type;
  final Value<String> name;
  final Value<String> url;
  final Value<String> thumbnail;
  final Value<int> fileSize;
  final Value<String> showFileSize;
  final Value<String> localFilePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ResourceCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.showFileSize = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ResourceCompanion.insert({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    required String type,
    required String name,
    required String url,
    required String thumbnail,
    this.fileSize = const Value.absent(),
    required String showFileSize,
    required String localFilePath,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : type = Value(type),
        name = Value(name),
        url = Value(url),
        thumbnail = Value(thumbnail),
        showFileSize = Value(showFileSize),
        localFilePath = Value(localFilePath);
  static Insertable<ResourceData> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? thumbnail,
    Expression<int>? fileSize,
    Expression<String>? showFileSize,
    Expression<String>? localFilePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (fileSize != null) 'file_size': fileSize,
      if (showFileSize != null) 'show_file_size': showFileSize,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ResourceCompanion copyWith(
      {Value<int>? id,
      Value<int?>? groupId,
      Value<String>? type,
      Value<String>? name,
      Value<String>? url,
      Value<String>? thumbnail,
      Value<int>? fileSize,
      Value<String>? showFileSize,
      Value<String>? localFilePath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ResourceCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      name: name ?? this.name,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      fileSize: fileSize ?? this.fileSize,
      showFileSize: showFileSize ?? this.showFileSize,
      localFilePath: localFilePath ?? this.localFilePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (showFileSize.present) {
      map['show_file_size'] = Variable<String>(showFileSize.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResourceCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('fileSize: $fileSize, ')
          ..write('showFileSize: $showFileSize, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TerminalGroupTable extends TerminalGroup
    with TableInfo<$TerminalGroupTable, TerminalGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TerminalGroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fatherIdMeta =
      const VerificationMeta('fatherId');
  @override
  late final GeneratedColumn<int> fatherId = GeneratedColumn<int>(
      'father_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, fatherId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'terminal_group';
  @override
  VerificationContext validateIntegrity(Insertable<TerminalGroupData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('father_id')) {
      context.handle(_fatherIdMeta,
          fatherId.isAcceptableOrUnknown(data['father_id']!, _fatherIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TerminalGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TerminalGroupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      fatherId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}father_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TerminalGroupTable createAlias(String alias) {
    return $TerminalGroupTable(attachedDatabase, alias);
  }
}

class TerminalGroupData extends DataClass
    implements Insertable<TerminalGroupData> {
  final int id;
  final String label;
  final int? fatherId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TerminalGroupData(
      {required this.id,
      required this.label,
      this.fatherId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || fatherId != null) {
      map['father_id'] = Variable<int>(fatherId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TerminalGroupCompanion toCompanion(bool nullToAbsent) {
    return TerminalGroupCompanion(
      id: Value(id),
      label: Value(label),
      fatherId: fatherId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TerminalGroupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TerminalGroupData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      fatherId: serializer.fromJson<int?>(json['fatherId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'fatherId': serializer.toJson<int?>(fatherId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TerminalGroupData copyWith(
          {int? id,
          String? label,
          Value<int?> fatherId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TerminalGroupData(
        id: id ?? this.id,
        label: label ?? this.label,
        fatherId: fatherId.present ? fatherId.value : this.fatherId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TerminalGroupData copyWithCompanion(TerminalGroupCompanion data) {
    return TerminalGroupData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      fatherId: data.fatherId.present ? data.fatherId.value : this.fatherId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TerminalGroupData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, fatherId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TerminalGroupData &&
          other.id == this.id &&
          other.label == this.label &&
          other.fatherId == this.fatherId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TerminalGroupCompanion extends UpdateCompanion<TerminalGroupData> {
  final Value<int> id;
  final Value<String> label;
  final Value<int?> fatherId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TerminalGroupCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TerminalGroupCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : label = Value(label);
  static Insertable<TerminalGroupData> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? fatherId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (fatherId != null) 'father_id': fatherId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TerminalGroupCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<int?>? fatherId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TerminalGroupCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      fatherId: fatherId ?? this.fatherId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (fatherId.present) {
      map['father_id'] = Variable<int>(fatherId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TerminalGroupCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TerminalTable extends Terminal
    with TableInfo<$TerminalTable, TerminalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TerminalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _terminalCodeMeta =
      const VerificationMeta('terminalCode');
  @override
  late final GeneratedColumn<String> terminalCode = GeneratedColumn<String>(
      'terminal_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pasWordMeta =
      const VerificationMeta('pasWord');
  @override
  late final GeneratedColumn<String> pasWord = GeneratedColumn<String>(
      'pas_word', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sversionMeta =
      const VerificationMeta('sversion');
  @override
  late final GeneratedColumn<String> sversion = GeneratedColumn<String>(
      'sversion', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<String> mac = GeneratedColumn<String>(
      'mac', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _updateTimeMeta =
      const VerificationMeta('updateTime');
  @override
  late final GeneratedColumn<String> updateTime = GeneratedColumn<String>(
      'update_time', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastControlMsgMeta =
      const VerificationMeta('lastControlMsg');
  @override
  late final GeneratedColumn<String> lastControlMsg = GeneratedColumn<String>(
      'last_control_msg', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        terminalCode,
        type,
        pasWord,
        resolution,
        sversion,
        version,
        mac,
        status,
        updateTime,
        lastControlMsg,
        groupId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'terminal';
  @override
  VerificationContext validateIntegrity(Insertable<TerminalData> instance,
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
    if (data.containsKey('terminal_code')) {
      context.handle(
          _terminalCodeMeta,
          terminalCode.isAcceptableOrUnknown(
              data['terminal_code']!, _terminalCodeMeta));
    } else if (isInserting) {
      context.missing(_terminalCodeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('pas_word')) {
      context.handle(_pasWordMeta,
          pasWord.isAcceptableOrUnknown(data['pas_word']!, _pasWordMeta));
    } else if (isInserting) {
      context.missing(_pasWordMeta);
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    } else if (isInserting) {
      context.missing(_resolutionMeta);
    }
    if (data.containsKey('sversion')) {
      context.handle(_sversionMeta,
          sversion.isAcceptableOrUnknown(data['sversion']!, _sversionMeta));
    } else if (isInserting) {
      context.missing(_sversionMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
          _macMeta, mac.isAcceptableOrUnknown(data['mac']!, _macMeta));
    } else if (isInserting) {
      context.missing(_macMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('update_time')) {
      context.handle(
          _updateTimeMeta,
          updateTime.isAcceptableOrUnknown(
              data['update_time']!, _updateTimeMeta));
    } else if (isInserting) {
      context.missing(_updateTimeMeta);
    }
    if (data.containsKey('last_control_msg')) {
      context.handle(
          _lastControlMsgMeta,
          lastControlMsg.isAcceptableOrUnknown(
              data['last_control_msg']!, _lastControlMsgMeta));
    } else if (isInserting) {
      context.missing(_lastControlMsgMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TerminalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TerminalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      terminalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}terminal_code'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      pasWord: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pas_word'])!,
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution'])!,
      sversion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sversion'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      mac: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mac'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      updateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}update_time'])!,
      lastControlMsg: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_control_msg'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TerminalTable createAlias(String alias) {
    return $TerminalTable(attachedDatabase, alias);
  }
}

class TerminalData extends DataClass implements Insertable<TerminalData> {
  final int id;
  final String name;
  final String terminalCode;
  final String type;
  final String pasWord;
  final String resolution;
  final String sversion;
  final String version;
  final String mac;
  final String status;
  final String updateTime;
  final String lastControlMsg;
  final int groupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TerminalData(
      {required this.id,
      required this.name,
      required this.terminalCode,
      required this.type,
      required this.pasWord,
      required this.resolution,
      required this.sversion,
      required this.version,
      required this.mac,
      required this.status,
      required this.updateTime,
      required this.lastControlMsg,
      required this.groupId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['terminal_code'] = Variable<String>(terminalCode);
    map['type'] = Variable<String>(type);
    map['pas_word'] = Variable<String>(pasWord);
    map['resolution'] = Variable<String>(resolution);
    map['sversion'] = Variable<String>(sversion);
    map['version'] = Variable<String>(version);
    map['mac'] = Variable<String>(mac);
    map['status'] = Variable<String>(status);
    map['update_time'] = Variable<String>(updateTime);
    map['last_control_msg'] = Variable<String>(lastControlMsg);
    map['group_id'] = Variable<int>(groupId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TerminalCompanion toCompanion(bool nullToAbsent) {
    return TerminalCompanion(
      id: Value(id),
      name: Value(name),
      terminalCode: Value(terminalCode),
      type: Value(type),
      pasWord: Value(pasWord),
      resolution: Value(resolution),
      sversion: Value(sversion),
      version: Value(version),
      mac: Value(mac),
      status: Value(status),
      updateTime: Value(updateTime),
      lastControlMsg: Value(lastControlMsg),
      groupId: Value(groupId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TerminalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TerminalData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      terminalCode: serializer.fromJson<String>(json['terminalCode']),
      type: serializer.fromJson<String>(json['type']),
      pasWord: serializer.fromJson<String>(json['pasWord']),
      resolution: serializer.fromJson<String>(json['resolution']),
      sversion: serializer.fromJson<String>(json['sversion']),
      version: serializer.fromJson<String>(json['version']),
      mac: serializer.fromJson<String>(json['mac']),
      status: serializer.fromJson<String>(json['status']),
      updateTime: serializer.fromJson<String>(json['updateTime']),
      lastControlMsg: serializer.fromJson<String>(json['lastControlMsg']),
      groupId: serializer.fromJson<int>(json['groupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'terminalCode': serializer.toJson<String>(terminalCode),
      'type': serializer.toJson<String>(type),
      'pasWord': serializer.toJson<String>(pasWord),
      'resolution': serializer.toJson<String>(resolution),
      'sversion': serializer.toJson<String>(sversion),
      'version': serializer.toJson<String>(version),
      'mac': serializer.toJson<String>(mac),
      'status': serializer.toJson<String>(status),
      'updateTime': serializer.toJson<String>(updateTime),
      'lastControlMsg': serializer.toJson<String>(lastControlMsg),
      'groupId': serializer.toJson<int>(groupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TerminalData copyWith(
          {int? id,
          String? name,
          String? terminalCode,
          String? type,
          String? pasWord,
          String? resolution,
          String? sversion,
          String? version,
          String? mac,
          String? status,
          String? updateTime,
          String? lastControlMsg,
          int? groupId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TerminalData(
        id: id ?? this.id,
        name: name ?? this.name,
        terminalCode: terminalCode ?? this.terminalCode,
        type: type ?? this.type,
        pasWord: pasWord ?? this.pasWord,
        resolution: resolution ?? this.resolution,
        sversion: sversion ?? this.sversion,
        version: version ?? this.version,
        mac: mac ?? this.mac,
        status: status ?? this.status,
        updateTime: updateTime ?? this.updateTime,
        lastControlMsg: lastControlMsg ?? this.lastControlMsg,
        groupId: groupId ?? this.groupId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TerminalData copyWithCompanion(TerminalCompanion data) {
    return TerminalData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      terminalCode: data.terminalCode.present
          ? data.terminalCode.value
          : this.terminalCode,
      type: data.type.present ? data.type.value : this.type,
      pasWord: data.pasWord.present ? data.pasWord.value : this.pasWord,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      sversion: data.sversion.present ? data.sversion.value : this.sversion,
      version: data.version.present ? data.version.value : this.version,
      mac: data.mac.present ? data.mac.value : this.mac,
      status: data.status.present ? data.status.value : this.status,
      updateTime:
          data.updateTime.present ? data.updateTime.value : this.updateTime,
      lastControlMsg: data.lastControlMsg.present
          ? data.lastControlMsg.value
          : this.lastControlMsg,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TerminalData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('terminalCode: $terminalCode, ')
          ..write('type: $type, ')
          ..write('pasWord: $pasWord, ')
          ..write('resolution: $resolution, ')
          ..write('sversion: $sversion, ')
          ..write('version: $version, ')
          ..write('mac: $mac, ')
          ..write('status: $status, ')
          ..write('updateTime: $updateTime, ')
          ..write('lastControlMsg: $lastControlMsg, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      terminalCode,
      type,
      pasWord,
      resolution,
      sversion,
      version,
      mac,
      status,
      updateTime,
      lastControlMsg,
      groupId,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TerminalData &&
          other.id == this.id &&
          other.name == this.name &&
          other.terminalCode == this.terminalCode &&
          other.type == this.type &&
          other.pasWord == this.pasWord &&
          other.resolution == this.resolution &&
          other.sversion == this.sversion &&
          other.version == this.version &&
          other.mac == this.mac &&
          other.status == this.status &&
          other.updateTime == this.updateTime &&
          other.lastControlMsg == this.lastControlMsg &&
          other.groupId == this.groupId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TerminalCompanion extends UpdateCompanion<TerminalData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> terminalCode;
  final Value<String> type;
  final Value<String> pasWord;
  final Value<String> resolution;
  final Value<String> sversion;
  final Value<String> version;
  final Value<String> mac;
  final Value<String> status;
  final Value<String> updateTime;
  final Value<String> lastControlMsg;
  final Value<int> groupId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TerminalCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.terminalCode = const Value.absent(),
    this.type = const Value.absent(),
    this.pasWord = const Value.absent(),
    this.resolution = const Value.absent(),
    this.sversion = const Value.absent(),
    this.version = const Value.absent(),
    this.mac = const Value.absent(),
    this.status = const Value.absent(),
    this.updateTime = const Value.absent(),
    this.lastControlMsg = const Value.absent(),
    this.groupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TerminalCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String terminalCode,
    required String type,
    required String pasWord,
    required String resolution,
    required String sversion,
    required String version,
    required String mac,
    required String status,
    required String updateTime,
    required String lastControlMsg,
    this.groupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        terminalCode = Value(terminalCode),
        type = Value(type),
        pasWord = Value(pasWord),
        resolution = Value(resolution),
        sversion = Value(sversion),
        version = Value(version),
        mac = Value(mac),
        status = Value(status),
        updateTime = Value(updateTime),
        lastControlMsg = Value(lastControlMsg);
  static Insertable<TerminalData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? terminalCode,
    Expression<String>? type,
    Expression<String>? pasWord,
    Expression<String>? resolution,
    Expression<String>? sversion,
    Expression<String>? version,
    Expression<String>? mac,
    Expression<String>? status,
    Expression<String>? updateTime,
    Expression<String>? lastControlMsg,
    Expression<int>? groupId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (terminalCode != null) 'terminal_code': terminalCode,
      if (type != null) 'type': type,
      if (pasWord != null) 'pas_word': pasWord,
      if (resolution != null) 'resolution': resolution,
      if (sversion != null) 'sversion': sversion,
      if (version != null) 'version': version,
      if (mac != null) 'mac': mac,
      if (status != null) 'status': status,
      if (updateTime != null) 'update_time': updateTime,
      if (lastControlMsg != null) 'last_control_msg': lastControlMsg,
      if (groupId != null) 'group_id': groupId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TerminalCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? terminalCode,
      Value<String>? type,
      Value<String>? pasWord,
      Value<String>? resolution,
      Value<String>? sversion,
      Value<String>? version,
      Value<String>? mac,
      Value<String>? status,
      Value<String>? updateTime,
      Value<String>? lastControlMsg,
      Value<int>? groupId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TerminalCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      terminalCode: terminalCode ?? this.terminalCode,
      type: type ?? this.type,
      pasWord: pasWord ?? this.pasWord,
      resolution: resolution ?? this.resolution,
      sversion: sversion ?? this.sversion,
      version: version ?? this.version,
      mac: mac ?? this.mac,
      status: status ?? this.status,
      updateTime: updateTime ?? this.updateTime,
      lastControlMsg: lastControlMsg ?? this.lastControlMsg,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (terminalCode.present) {
      map['terminal_code'] = Variable<String>(terminalCode.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pasWord.present) {
      map['pas_word'] = Variable<String>(pasWord.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (sversion.present) {
      map['sversion'] = Variable<String>(sversion.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (mac.present) {
      map['mac'] = Variable<String>(mac.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updateTime.present) {
      map['update_time'] = Variable<String>(updateTime.value);
    }
    if (lastControlMsg.present) {
      map['last_control_msg'] = Variable<String>(lastControlMsg.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TerminalCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('terminalCode: $terminalCode, ')
          ..write('type: $type, ')
          ..write('pasWord: $pasWord, ')
          ..write('resolution: $resolution, ')
          ..write('sversion: $sversion, ')
          ..write('version: $version, ')
          ..write('mac: $mac, ')
          ..write('status: $status, ')
          ..write('updateTime: $updateTime, ')
          ..write('lastControlMsg: $lastControlMsg, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, Template> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creatorMeta =
      const VerificationMeta('creator');
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
      'creator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
      'desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resolutionMeta =
      const VerificationMeta('resolution');
  @override
  late final GeneratedColumn<String> resolution = GeneratedColumn<String>(
      'resolution', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previewMeta =
      const VerificationMeta('preview');
  @override
  late final GeneratedColumn<String> preview = GeneratedColumn<String>(
      'preview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _terminalTypeMeta =
      const VerificationMeta('terminalType');
  @override
  late final GeneratedColumn<String> terminalType = GeneratedColumn<String>(
      'terminal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        body,
        creator,
        desc,
        groupId,
        resolution,
        width,
        height,
        name,
        preview,
        terminalType,
        type,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(Insertable<Template> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('creator')) {
      context.handle(_creatorMeta,
          creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta));
    } else if (isInserting) {
      context.missing(_creatorMeta);
    }
    if (data.containsKey('desc')) {
      context.handle(
          _descMeta, desc.isAcceptableOrUnknown(data['desc']!, _descMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('resolution')) {
      context.handle(
          _resolutionMeta,
          resolution.isAcceptableOrUnknown(
              data['resolution']!, _resolutionMeta));
    } else if (isInserting) {
      context.missing(_resolutionMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('preview')) {
      context.handle(_previewMeta,
          preview.isAcceptableOrUnknown(data['preview']!, _previewMeta));
    }
    if (data.containsKey('terminal_type')) {
      context.handle(
          _terminalTypeMeta,
          terminalType.isAcceptableOrUnknown(
              data['terminal_type']!, _terminalTypeMeta));
    } else if (isInserting) {
      context.missing(_terminalTypeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Template map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Template(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      creator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator'])!,
      desc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      resolution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resolution'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      preview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preview']),
      terminalType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}terminal_type'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class Template extends DataClass implements Insertable<Template> {
  final int id;
  final String? body;
  final String creator;
  final String? desc;
  final int groupId;
  final String resolution;
  final int width;
  final int height;
  final String name;
  final String? preview;
  final String terminalType;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Template(
      {required this.id,
      this.body,
      required this.creator,
      this.desc,
      required this.groupId,
      required this.resolution,
      required this.width,
      required this.height,
      required this.name,
      this.preview,
      required this.terminalType,
      required this.type,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['creator'] = Variable<String>(creator);
    if (!nullToAbsent || desc != null) {
      map['desc'] = Variable<String>(desc);
    }
    map['group_id'] = Variable<int>(groupId);
    map['resolution'] = Variable<String>(resolution);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || preview != null) {
      map['preview'] = Variable<String>(preview);
    }
    map['terminal_type'] = Variable<String>(terminalType);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      creator: Value(creator),
      desc: desc == null && nullToAbsent ? const Value.absent() : Value(desc),
      groupId: Value(groupId),
      resolution: Value(resolution),
      width: Value(width),
      height: Value(height),
      name: Value(name),
      preview: preview == null && nullToAbsent
          ? const Value.absent()
          : Value(preview),
      terminalType: Value(terminalType),
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Template.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Template(
      id: serializer.fromJson<int>(json['id']),
      body: serializer.fromJson<String?>(json['body']),
      creator: serializer.fromJson<String>(json['creator']),
      desc: serializer.fromJson<String?>(json['desc']),
      groupId: serializer.fromJson<int>(json['groupId']),
      resolution: serializer.fromJson<String>(json['resolution']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      name: serializer.fromJson<String>(json['name']),
      preview: serializer.fromJson<String?>(json['preview']),
      terminalType: serializer.fromJson<String>(json['terminalType']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'body': serializer.toJson<String?>(body),
      'creator': serializer.toJson<String>(creator),
      'desc': serializer.toJson<String?>(desc),
      'groupId': serializer.toJson<int>(groupId),
      'resolution': serializer.toJson<String>(resolution),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'name': serializer.toJson<String>(name),
      'preview': serializer.toJson<String?>(preview),
      'terminalType': serializer.toJson<String>(terminalType),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Template copyWith(
          {int? id,
          Value<String?> body = const Value.absent(),
          String? creator,
          Value<String?> desc = const Value.absent(),
          int? groupId,
          String? resolution,
          int? width,
          int? height,
          String? name,
          Value<String?> preview = const Value.absent(),
          String? terminalType,
          String? type,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Template(
        id: id ?? this.id,
        body: body.present ? body.value : this.body,
        creator: creator ?? this.creator,
        desc: desc.present ? desc.value : this.desc,
        groupId: groupId ?? this.groupId,
        resolution: resolution ?? this.resolution,
        width: width ?? this.width,
        height: height ?? this.height,
        name: name ?? this.name,
        preview: preview.present ? preview.value : this.preview,
        terminalType: terminalType ?? this.terminalType,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Template copyWithCompanion(TemplatesCompanion data) {
    return Template(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      creator: data.creator.present ? data.creator.value : this.creator,
      desc: data.desc.present ? data.desc.value : this.desc,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      resolution:
          data.resolution.present ? data.resolution.value : this.resolution,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      name: data.name.present ? data.name.value : this.name,
      preview: data.preview.present ? data.preview.value : this.preview,
      terminalType: data.terminalType.present
          ? data.terminalType.value
          : this.terminalType,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Template(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('creator: $creator, ')
          ..write('desc: $desc, ')
          ..write('groupId: $groupId, ')
          ..write('resolution: $resolution, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('name: $name, ')
          ..write('preview: $preview, ')
          ..write('terminalType: $terminalType, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, body, creator, desc, groupId, resolution,
      width, height, name, preview, terminalType, type, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Template &&
          other.id == this.id &&
          other.body == this.body &&
          other.creator == this.creator &&
          other.desc == this.desc &&
          other.groupId == this.groupId &&
          other.resolution == this.resolution &&
          other.width == this.width &&
          other.height == this.height &&
          other.name == this.name &&
          other.preview == this.preview &&
          other.terminalType == this.terminalType &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TemplatesCompanion extends UpdateCompanion<Template> {
  final Value<int> id;
  final Value<String?> body;
  final Value<String> creator;
  final Value<String?> desc;
  final Value<int> groupId;
  final Value<String> resolution;
  final Value<int> width;
  final Value<int> height;
  final Value<String> name;
  final Value<String?> preview;
  final Value<String> terminalType;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.creator = const Value.absent(),
    this.desc = const Value.absent(),
    this.groupId = const Value.absent(),
    this.resolution = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.name = const Value.absent(),
    this.preview = const Value.absent(),
    this.terminalType = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TemplatesCompanion.insert({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    required String creator,
    this.desc = const Value.absent(),
    required int groupId,
    required String resolution,
    required int width,
    required int height,
    required String name,
    this.preview = const Value.absent(),
    required String terminalType,
    required String type,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : creator = Value(creator),
        groupId = Value(groupId),
        resolution = Value(resolution),
        width = Value(width),
        height = Value(height),
        name = Value(name),
        terminalType = Value(terminalType),
        type = Value(type);
  static Insertable<Template> custom({
    Expression<int>? id,
    Expression<String>? body,
    Expression<String>? creator,
    Expression<String>? desc,
    Expression<int>? groupId,
    Expression<String>? resolution,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? name,
    Expression<String>? preview,
    Expression<String>? terminalType,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (creator != null) 'creator': creator,
      if (desc != null) 'desc': desc,
      if (groupId != null) 'group_id': groupId,
      if (resolution != null) 'resolution': resolution,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (name != null) 'name': name,
      if (preview != null) 'preview': preview,
      if (terminalType != null) 'terminal_type': terminalType,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? body,
      Value<String>? creator,
      Value<String?>? desc,
      Value<int>? groupId,
      Value<String>? resolution,
      Value<int>? width,
      Value<int>? height,
      Value<String>? name,
      Value<String?>? preview,
      Value<String>? terminalType,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TemplatesCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      creator: creator ?? this.creator,
      desc: desc ?? this.desc,
      groupId: groupId ?? this.groupId,
      resolution: resolution ?? this.resolution,
      width: width ?? this.width,
      height: height ?? this.height,
      name: name ?? this.name,
      preview: preview ?? this.preview,
      terminalType: terminalType ?? this.terminalType,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (resolution.present) {
      map['resolution'] = Variable<String>(resolution.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (preview.present) {
      map['preview'] = Variable<String>(preview.value);
    }
    if (terminalType.present) {
      map['terminal_type'] = Variable<String>(terminalType.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('creator: $creator, ')
          ..write('desc: $desc, ')
          ..write('groupId: $groupId, ')
          ..write('resolution: $resolution, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('name: $name, ')
          ..write('preview: $preview, ')
          ..write('terminalType: $terminalType, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TemplateItemsTable extends TemplateItems
    with TableInfo<$TemplateItemsTable, TemplateItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES templates(id)');
  static const VerificationMeta _backGroundMeta =
      const VerificationMeta('backGround');
  @override
  late final GeneratedColumn<String> backGround = GeneratedColumn<String>(
      'back_ground', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resourceIdMeta =
      const VerificationMeta('resourceId');
  @override
  late final GeneratedColumn<String> resourceId = GeneratedColumn<String>(
      'resource_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
      'width', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<int> x = GeneratedColumn<int>(
      'x', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<int> y = GeneratedColumn<int>(
      'y', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _zIndexMeta = const VerificationMeta('zIndex');
  @override
  late final GeneratedColumn<int> zIndex = GeneratedColumn<int>(
      'z_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        templateId,
        backGround,
        resourceId,
        height,
        name,
        type,
        width,
        x,
        y,
        zIndex
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_items';
  @override
  VerificationContext validateIntegrity(Insertable<TemplateItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('back_ground')) {
      context.handle(
          _backGroundMeta,
          backGround.isAcceptableOrUnknown(
              data['back_ground']!, _backGroundMeta));
    }
    if (data.containsKey('resource_id')) {
      context.handle(
          _resourceIdMeta,
          resourceId.isAcceptableOrUnknown(
              data['resource_id']!, _resourceIdMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('z_index')) {
      context.handle(_zIndexMeta,
          zIndex.isAcceptableOrUnknown(data['z_index']!, _zIndexMeta));
    } else if (isInserting) {
      context.missing(_zIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TemplateItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id']),
      backGround: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}back_ground']),
      resourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resource_id']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}width'])!,
      x: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}x'])!,
      y: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}y'])!,
      zIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}z_index'])!,
    );
  }

  @override
  $TemplateItemsTable createAlias(String alias) {
    return $TemplateItemsTable(attachedDatabase, alias);
  }
}

class TemplateItem extends DataClass implements Insertable<TemplateItem> {
  final String id;
  final int? templateId;
  final String? backGround;
  final String? resourceId;
  final double height;
  final String name;
  final String type;
  final double width;
  final int x;
  final int y;
  final int zIndex;
  const TemplateItem(
      {required this.id,
      this.templateId,
      this.backGround,
      this.resourceId,
      required this.height,
      required this.name,
      required this.type,
      required this.width,
      required this.x,
      required this.y,
      required this.zIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    if (!nullToAbsent || backGround != null) {
      map['back_ground'] = Variable<String>(backGround);
    }
    if (!nullToAbsent || resourceId != null) {
      map['resource_id'] = Variable<String>(resourceId);
    }
    map['height'] = Variable<double>(height);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['width'] = Variable<double>(width);
    map['x'] = Variable<int>(x);
    map['y'] = Variable<int>(y);
    map['z_index'] = Variable<int>(zIndex);
    return map;
  }

  TemplateItemsCompanion toCompanion(bool nullToAbsent) {
    return TemplateItemsCompanion(
      id: Value(id),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      backGround: backGround == null && nullToAbsent
          ? const Value.absent()
          : Value(backGround),
      resourceId: resourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(resourceId),
      height: Value(height),
      name: Value(name),
      type: Value(type),
      width: Value(width),
      x: Value(x),
      y: Value(y),
      zIndex: Value(zIndex),
    );
  }

  factory TemplateItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateItem(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      backGround: serializer.fromJson<String?>(json['backGround']),
      resourceId: serializer.fromJson<String?>(json['resourceId']),
      height: serializer.fromJson<double>(json['height']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      width: serializer.fromJson<double>(json['width']),
      x: serializer.fromJson<int>(json['x']),
      y: serializer.fromJson<int>(json['y']),
      zIndex: serializer.fromJson<int>(json['zIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<int?>(templateId),
      'backGround': serializer.toJson<String?>(backGround),
      'resourceId': serializer.toJson<String?>(resourceId),
      'height': serializer.toJson<double>(height),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'width': serializer.toJson<double>(width),
      'x': serializer.toJson<int>(x),
      'y': serializer.toJson<int>(y),
      'zIndex': serializer.toJson<int>(zIndex),
    };
  }

  TemplateItem copyWith(
          {String? id,
          Value<int?> templateId = const Value.absent(),
          Value<String?> backGround = const Value.absent(),
          Value<String?> resourceId = const Value.absent(),
          double? height,
          String? name,
          String? type,
          double? width,
          int? x,
          int? y,
          int? zIndex}) =>
      TemplateItem(
        id: id ?? this.id,
        templateId: templateId.present ? templateId.value : this.templateId,
        backGround: backGround.present ? backGround.value : this.backGround,
        resourceId: resourceId.present ? resourceId.value : this.resourceId,
        height: height ?? this.height,
        name: name ?? this.name,
        type: type ?? this.type,
        width: width ?? this.width,
        x: x ?? this.x,
        y: y ?? this.y,
        zIndex: zIndex ?? this.zIndex,
      );
  TemplateItem copyWithCompanion(TemplateItemsCompanion data) {
    return TemplateItem(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      backGround:
          data.backGround.present ? data.backGround.value : this.backGround,
      resourceId:
          data.resourceId.present ? data.resourceId.value : this.resourceId,
      height: data.height.present ? data.height.value : this.height,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      width: data.width.present ? data.width.value : this.width,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      zIndex: data.zIndex.present ? data.zIndex.value : this.zIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItem(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('backGround: $backGround, ')
          ..write('resourceId: $resourceId, ')
          ..write('height: $height, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('zIndex: $zIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, backGround, resourceId,
      height, name, type, width, x, y, zIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateItem &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.backGround == this.backGround &&
          other.resourceId == this.resourceId &&
          other.height == this.height &&
          other.name == this.name &&
          other.type == this.type &&
          other.width == this.width &&
          other.x == this.x &&
          other.y == this.y &&
          other.zIndex == this.zIndex);
}

class TemplateItemsCompanion extends UpdateCompanion<TemplateItem> {
  final Value<String> id;
  final Value<int?> templateId;
  final Value<String?> backGround;
  final Value<String?> resourceId;
  final Value<double> height;
  final Value<String> name;
  final Value<String> type;
  final Value<double> width;
  final Value<int> x;
  final Value<int> y;
  final Value<int> zIndex;
  final Value<int> rowid;
  const TemplateItemsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.backGround = const Value.absent(),
    this.resourceId = const Value.absent(),
    this.height = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.width = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.zIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplateItemsCompanion.insert({
    required String id,
    this.templateId = const Value.absent(),
    this.backGround = const Value.absent(),
    this.resourceId = const Value.absent(),
    required double height,
    required String name,
    required String type,
    required double width,
    required int x,
    required int y,
    required int zIndex,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        height = Value(height),
        name = Value(name),
        type = Value(type),
        width = Value(width),
        x = Value(x),
        y = Value(y),
        zIndex = Value(zIndex);
  static Insertable<TemplateItem> custom({
    Expression<String>? id,
    Expression<int>? templateId,
    Expression<String>? backGround,
    Expression<String>? resourceId,
    Expression<double>? height,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? width,
    Expression<int>? x,
    Expression<int>? y,
    Expression<int>? zIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (backGround != null) 'back_ground': backGround,
      if (resourceId != null) 'resource_id': resourceId,
      if (height != null) 'height': height,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (width != null) 'width': width,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (zIndex != null) 'z_index': zIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplateItemsCompanion copyWith(
      {Value<String>? id,
      Value<int?>? templateId,
      Value<String?>? backGround,
      Value<String?>? resourceId,
      Value<double>? height,
      Value<String>? name,
      Value<String>? type,
      Value<double>? width,
      Value<int>? x,
      Value<int>? y,
      Value<int>? zIndex,
      Value<int>? rowid}) {
    return TemplateItemsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      backGround: backGround ?? this.backGround,
      resourceId: resourceId ?? this.resourceId,
      height: height ?? this.height,
      name: name ?? this.name,
      type: type ?? this.type,
      width: width ?? this.width,
      x: x ?? this.x,
      y: y ?? this.y,
      zIndex: zIndex ?? this.zIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (backGround.present) {
      map['back_ground'] = Variable<String>(backGround.value);
    }
    if (resourceId.present) {
      map['resource_id'] = Variable<String>(resourceId.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (x.present) {
      map['x'] = Variable<int>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<int>(y.value);
    }
    if (zIndex.present) {
      map['z_index'] = Variable<int>(zIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItemsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('backGround: $backGround, ')
          ..write('resourceId: $resourceId, ')
          ..write('height: $height, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('zIndex: $zIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CmdInfoTable extends CmdInfo with TableInfo<$CmdInfoTable, CmdInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CmdInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pushTypeMeta =
      const VerificationMeta('pushType');
  @override
  late final GeneratedColumn<String> pushType = GeneratedColumn<String>(
      'push_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _flagMeta = const VerificationMeta('flag');
  @override
  late final GeneratedColumn<int> flag = GeneratedColumn<int>(
      'flag', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, pushType, flag, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cmd_info';
  @override
  VerificationContext validateIntegrity(Insertable<CmdInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('push_type')) {
      context.handle(_pushTypeMeta,
          pushType.isAcceptableOrUnknown(data['push_type']!, _pushTypeMeta));
    } else if (isInserting) {
      context.missing(_pushTypeMeta);
    }
    if (data.containsKey('flag')) {
      context.handle(
          _flagMeta, flag.isAcceptableOrUnknown(data['flag']!, _flagMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CmdInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CmdInfoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pushType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}push_type'])!,
      flag: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}flag'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CmdInfoTable createAlias(String alias) {
    return $CmdInfoTable(attachedDatabase, alias);
  }
}

class CmdInfoData extends DataClass implements Insertable<CmdInfoData> {
  final int id;
  final String pushType;
  final int flag;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CmdInfoData(
      {required this.id,
      required this.pushType,
      required this.flag,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['push_type'] = Variable<String>(pushType);
    map['flag'] = Variable<int>(flag);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CmdInfoCompanion toCompanion(bool nullToAbsent) {
    return CmdInfoCompanion(
      id: Value(id),
      pushType: Value(pushType),
      flag: Value(flag),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CmdInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CmdInfoData(
      id: serializer.fromJson<int>(json['id']),
      pushType: serializer.fromJson<String>(json['pushType']),
      flag: serializer.fromJson<int>(json['flag']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pushType': serializer.toJson<String>(pushType),
      'flag': serializer.toJson<int>(flag),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CmdInfoData copyWith(
          {int? id,
          String? pushType,
          int? flag,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CmdInfoData(
        id: id ?? this.id,
        pushType: pushType ?? this.pushType,
        flag: flag ?? this.flag,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CmdInfoData copyWithCompanion(CmdInfoCompanion data) {
    return CmdInfoData(
      id: data.id.present ? data.id.value : this.id,
      pushType: data.pushType.present ? data.pushType.value : this.pushType,
      flag: data.flag.present ? data.flag.value : this.flag,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CmdInfoData(')
          ..write('id: $id, ')
          ..write('pushType: $pushType, ')
          ..write('flag: $flag, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pushType, flag, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CmdInfoData &&
          other.id == this.id &&
          other.pushType == this.pushType &&
          other.flag == this.flag &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CmdInfoCompanion extends UpdateCompanion<CmdInfoData> {
  final Value<int> id;
  final Value<String> pushType;
  final Value<int> flag;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CmdInfoCompanion({
    this.id = const Value.absent(),
    this.pushType = const Value.absent(),
    this.flag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CmdInfoCompanion.insert({
    this.id = const Value.absent(),
    required String pushType,
    this.flag = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : pushType = Value(pushType);
  static Insertable<CmdInfoData> custom({
    Expression<int>? id,
    Expression<String>? pushType,
    Expression<int>? flag,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pushType != null) 'push_type': pushType,
      if (flag != null) 'flag': flag,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CmdInfoCompanion copyWith(
      {Value<int>? id,
      Value<String>? pushType,
      Value<int>? flag,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CmdInfoCompanion(
      id: id ?? this.id,
      pushType: pushType ?? this.pushType,
      flag: flag ?? this.flag,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pushType.present) {
      map['push_type'] = Variable<String>(pushType.value);
    }
    if (flag.present) {
      map['flag'] = Variable<int>(flag.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CmdInfoCompanion(')
          ..write('id: $id, ')
          ..write('pushType: $pushType, ')
          ..write('flag: $flag, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgramGroupTable extends ProgramGroup
    with TableInfo<$ProgramGroupTable, ProgramGroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramGroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _fatherIdMeta =
      const VerificationMeta('fatherId');
  @override
  late final GeneratedColumn<int> fatherId = GeneratedColumn<int>(
      'father_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, fatherId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_group';
  @override
  VerificationContext validateIntegrity(Insertable<ProgramGroupData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('father_id')) {
      context.handle(_fatherIdMeta,
          fatherId.isAcceptableOrUnknown(data['father_id']!, _fatherIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramGroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramGroupData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      fatherId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}father_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProgramGroupTable createAlias(String alias) {
    return $ProgramGroupTable(attachedDatabase, alias);
  }
}

class ProgramGroupData extends DataClass
    implements Insertable<ProgramGroupData> {
  final int id;
  final String label;
  final int? fatherId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProgramGroupData(
      {required this.id,
      required this.label,
      this.fatherId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || fatherId != null) {
      map['father_id'] = Variable<int>(fatherId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProgramGroupCompanion toCompanion(bool nullToAbsent) {
    return ProgramGroupCompanion(
      id: Value(id),
      label: Value(label),
      fatherId: fatherId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProgramGroupData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramGroupData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      fatherId: serializer.fromJson<int?>(json['fatherId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'fatherId': serializer.toJson<int?>(fatherId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProgramGroupData copyWith(
          {int? id,
          String? label,
          Value<int?> fatherId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProgramGroupData(
        id: id ?? this.id,
        label: label ?? this.label,
        fatherId: fatherId.present ? fatherId.value : this.fatherId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProgramGroupData copyWithCompanion(ProgramGroupCompanion data) {
    return ProgramGroupData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      fatherId: data.fatherId.present ? data.fatherId.value : this.fatherId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramGroupData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, fatherId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramGroupData &&
          other.id == this.id &&
          other.label == this.label &&
          other.fatherId == this.fatherId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProgramGroupCompanion extends UpdateCompanion<ProgramGroupData> {
  final Value<int> id;
  final Value<String> label;
  final Value<int?> fatherId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProgramGroupCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProgramGroupCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.fatherId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : label = Value(label);
  static Insertable<ProgramGroupData> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? fatherId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (fatherId != null) 'father_id': fatherId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProgramGroupCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<int?>? fatherId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProgramGroupCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      fatherId: fatherId ?? this.fatherId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (fatherId.present) {
      map['father_id'] = Variable<int>(fatherId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramGroupCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('fatherId: $fatherId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgramTable extends Program with TableInfo<$ProgramTable, ProgramData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _modelIdMeta =
      const VerificationMeta('modelId');
  @override
  late final GeneratedColumn<int> modelId = GeneratedColumn<int>(
      'model_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _previewMeta =
      const VerificationMeta('preview');
  @override
  late final GeneratedColumn<String> preview = GeneratedColumn<String>(
      'preview', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, modelId, name, preview, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program';
  @override
  VerificationContext validateIntegrity(Insertable<ProgramData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(_modelIdMeta,
          modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta));
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('preview')) {
      context.handle(_previewMeta,
          preview.isAcceptableOrUnknown(data['preview']!, _previewMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      modelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}model_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      preview: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preview']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProgramTable createAlias(String alias) {
    return $ProgramTable(attachedDatabase, alias);
  }
}

class ProgramData extends DataClass implements Insertable<ProgramData> {
  final int id;
  final int groupId;
  final int modelId;
  final String name;
  final String? preview;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProgramData(
      {required this.id,
      required this.groupId,
      required this.modelId,
      required this.name,
      this.preview,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['model_id'] = Variable<int>(modelId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || preview != null) {
      map['preview'] = Variable<String>(preview);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProgramCompanion toCompanion(bool nullToAbsent) {
    return ProgramCompanion(
      id: Value(id),
      groupId: Value(groupId),
      modelId: Value(modelId),
      name: Value(name),
      preview: preview == null && nullToAbsent
          ? const Value.absent()
          : Value(preview),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProgramData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramData(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      modelId: serializer.fromJson<int>(json['modelId']),
      name: serializer.fromJson<String>(json['name']),
      preview: serializer.fromJson<String?>(json['preview']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'modelId': serializer.toJson<int>(modelId),
      'name': serializer.toJson<String>(name),
      'preview': serializer.toJson<String?>(preview),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProgramData copyWith(
          {int? id,
          int? groupId,
          int? modelId,
          String? name,
          Value<String?> preview = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProgramData(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        modelId: modelId ?? this.modelId,
        name: name ?? this.name,
        preview: preview.present ? preview.value : this.preview,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProgramData copyWithCompanion(ProgramCompanion data) {
    return ProgramData(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      name: data.name.present ? data.name.value : this.name,
      preview: data.preview.present ? data.preview.value : this.preview,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('modelId: $modelId, ')
          ..write('name: $name, ')
          ..write('preview: $preview, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, modelId, name, preview, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.modelId == this.modelId &&
          other.name == this.name &&
          other.preview == this.preview &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProgramCompanion extends UpdateCompanion<ProgramData> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> modelId;
  final Value<String> name;
  final Value<String?> preview;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProgramCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.modelId = const Value.absent(),
    this.name = const Value.absent(),
    this.preview = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProgramCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int modelId,
    required String name,
    this.preview = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : groupId = Value(groupId),
        modelId = Value(modelId),
        name = Value(name);
  static Insertable<ProgramData> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? modelId,
    Expression<String>? name,
    Expression<String>? preview,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (modelId != null) 'model_id': modelId,
      if (name != null) 'name': name,
      if (preview != null) 'preview': preview,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProgramCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<int>? modelId,
      Value<String>? name,
      Value<String?>? preview,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ProgramCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      modelId: modelId ?? this.modelId,
      name: name ?? this.name,
      preview: preview ?? this.preview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<int>(modelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (preview.present) {
      map['preview'] = Variable<String>(preview.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('modelId: $modelId, ')
          ..write('name: $name, ')
          ..write('preview: $preview, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgramItemsTable extends ProgramItems
    with TableInfo<$ProgramItemsTable, ProgramItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _programIdMeta =
      const VerificationMeta('programId');
  @override
  late final GeneratedColumn<int> programId = GeneratedColumn<int>(
      'program_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES program(id)');
  static const VerificationMeta _itemsIdMeta =
      const VerificationMeta('itemsId');
  @override
  late final GeneratedColumn<String> itemsId = GeneratedColumn<String>(
      'items_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, programId, itemsId, url];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_items';
  @override
  VerificationContext validateIntegrity(Insertable<ProgramItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('program_id')) {
      context.handle(_programIdMeta,
          programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta));
    }
    if (data.containsKey('items_id')) {
      context.handle(_itemsIdMeta,
          itemsId.isAcceptableOrUnknown(data['items_id']!, _itemsIdMeta));
    } else if (isInserting) {
      context.missing(_itemsIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      programId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}program_id']),
      itemsId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
    );
  }

  @override
  $ProgramItemsTable createAlias(String alias) {
    return $ProgramItemsTable(attachedDatabase, alias);
  }
}

class ProgramItem extends DataClass implements Insertable<ProgramItem> {
  final int id;
  final int? programId;
  final String itemsId;
  final String url;
  const ProgramItem(
      {required this.id,
      this.programId,
      required this.itemsId,
      required this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || programId != null) {
      map['program_id'] = Variable<int>(programId);
    }
    map['items_id'] = Variable<String>(itemsId);
    map['url'] = Variable<String>(url);
    return map;
  }

  ProgramItemsCompanion toCompanion(bool nullToAbsent) {
    return ProgramItemsCompanion(
      id: Value(id),
      programId: programId == null && nullToAbsent
          ? const Value.absent()
          : Value(programId),
      itemsId: Value(itemsId),
      url: Value(url),
    );
  }

  factory ProgramItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramItem(
      id: serializer.fromJson<int>(json['id']),
      programId: serializer.fromJson<int?>(json['programId']),
      itemsId: serializer.fromJson<String>(json['itemsId']),
      url: serializer.fromJson<String>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'programId': serializer.toJson<int?>(programId),
      'itemsId': serializer.toJson<String>(itemsId),
      'url': serializer.toJson<String>(url),
    };
  }

  ProgramItem copyWith(
          {int? id,
          Value<int?> programId = const Value.absent(),
          String? itemsId,
          String? url}) =>
      ProgramItem(
        id: id ?? this.id,
        programId: programId.present ? programId.value : this.programId,
        itemsId: itemsId ?? this.itemsId,
        url: url ?? this.url,
      );
  ProgramItem copyWithCompanion(ProgramItemsCompanion data) {
    return ProgramItem(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      itemsId: data.itemsId.present ? data.itemsId.value : this.itemsId,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramItem(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('itemsId: $itemsId, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, programId, itemsId, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramItem &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.itemsId == this.itemsId &&
          other.url == this.url);
}

class ProgramItemsCompanion extends UpdateCompanion<ProgramItem> {
  final Value<int> id;
  final Value<int?> programId;
  final Value<String> itemsId;
  final Value<String> url;
  const ProgramItemsCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.itemsId = const Value.absent(),
    this.url = const Value.absent(),
  });
  ProgramItemsCompanion.insert({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    required String itemsId,
    required String url,
  })  : itemsId = Value(itemsId),
        url = Value(url);
  static Insertable<ProgramItem> custom({
    Expression<int>? id,
    Expression<int>? programId,
    Expression<String>? itemsId,
    Expression<String>? url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (itemsId != null) 'items_id': itemsId,
      if (url != null) 'url': url,
    });
  }

  ProgramItemsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? programId,
      Value<String>? itemsId,
      Value<String>? url}) {
    return ProgramItemsCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      itemsId: itemsId ?? this.itemsId,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<int>(programId.value);
    }
    if (itemsId.present) {
      map['items_id'] = Variable<String>(itemsId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramItemsCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('itemsId: $itemsId, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $ServerPublishTable extends ServerPublish
    with TableInfo<$ServerPublishTable, ServerPublishData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerPublishTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _programNameMeta =
      const VerificationMeta('programName');
  @override
  late final GeneratedColumn<String> programName = GeneratedColumn<String>(
      'program_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _disStrategyMeta =
      const VerificationMeta('disStrategy');
  @override
  late final GeneratedColumn<String> disStrategy = GeneratedColumn<String>(
      'dis_strategy', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('null'));
  static const VerificationMeta _disTypeMeta =
      const VerificationMeta('disType');
  @override
  late final GeneratedColumn<String> disType = GeneratedColumn<String>(
      'dis_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('null'));
  static const VerificationMeta _invalidTimeMeta =
      const VerificationMeta('invalidTime');
  @override
  late final GeneratedColumn<String> invalidTime = GeneratedColumn<String>(
      'invalid_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _makeTimeMeta =
      const VerificationMeta('makeTime');
  @override
  late final GeneratedColumn<String> makeTime = GeneratedColumn<String>(
      'make_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _playModeMeta =
      const VerificationMeta('playMode');
  @override
  late final GeneratedColumn<String> playMode = GeneratedColumn<String>(
      'play_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('loop'));
  static const VerificationMeta _proIdMeta = const VerificationMeta('proId');
  @override
  late final GeneratedColumn<String> proId = GeneratedColumn<String>(
      'pro_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _proTypeMeta =
      const VerificationMeta('proType');
  @override
  late final GeneratedColumn<int> proType = GeneratedColumn<int>(
      'pro_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _publisherMeta =
      const VerificationMeta('publisher');
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('admin'));
  static const VerificationMeta _terminalIdMeta =
      const VerificationMeta('terminalId');
  @override
  late final GeneratedColumn<String> terminalId = GeneratedColumn<String>(
      'terminal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('date'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        programName,
        date,
        disStrategy,
        disType,
        invalidTime,
        makeTime,
        playMode,
        proId,
        proType,
        publisher,
        terminalId,
        time,
        type,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_publish';
  @override
  VerificationContext validateIntegrity(Insertable<ServerPublishData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('program_name')) {
      context.handle(
          _programNameMeta,
          programName.isAcceptableOrUnknown(
              data['program_name']!, _programNameMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('dis_strategy')) {
      context.handle(
          _disStrategyMeta,
          disStrategy.isAcceptableOrUnknown(
              data['dis_strategy']!, _disStrategyMeta));
    }
    if (data.containsKey('dis_type')) {
      context.handle(_disTypeMeta,
          disType.isAcceptableOrUnknown(data['dis_type']!, _disTypeMeta));
    }
    if (data.containsKey('invalid_time')) {
      context.handle(
          _invalidTimeMeta,
          invalidTime.isAcceptableOrUnknown(
              data['invalid_time']!, _invalidTimeMeta));
    }
    if (data.containsKey('make_time')) {
      context.handle(_makeTimeMeta,
          makeTime.isAcceptableOrUnknown(data['make_time']!, _makeTimeMeta));
    }
    if (data.containsKey('play_mode')) {
      context.handle(_playModeMeta,
          playMode.isAcceptableOrUnknown(data['play_mode']!, _playModeMeta));
    }
    if (data.containsKey('pro_id')) {
      context.handle(
          _proIdMeta, proId.isAcceptableOrUnknown(data['pro_id']!, _proIdMeta));
    }
    if (data.containsKey('pro_type')) {
      context.handle(_proTypeMeta,
          proType.isAcceptableOrUnknown(data['pro_type']!, _proTypeMeta));
    }
    if (data.containsKey('publisher')) {
      context.handle(_publisherMeta,
          publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta));
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
          _terminalIdMeta,
          terminalId.isAcceptableOrUnknown(
              data['terminal_id']!, _terminalIdMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerPublishData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerPublishData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      programName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}program_name']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      disStrategy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dis_strategy'])!,
      disType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dis_type'])!,
      invalidTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invalid_time']),
      makeTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}make_time']),
      playMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}play_mode'])!,
      proId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pro_id'])!,
      proType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pro_type'])!,
      publisher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}publisher'])!,
      terminalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}terminal_id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ServerPublishTable createAlias(String alias) {
    return $ServerPublishTable(attachedDatabase, alias);
  }
}

class ServerPublishData extends DataClass
    implements Insertable<ServerPublishData> {
  final int id;
  final String? programName;
  final String? date;
  final String disStrategy;
  final String disType;
  final String? invalidTime;
  final String? makeTime;
  final String playMode;
  final String proId;
  final int proType;
  final String publisher;
  final String terminalId;
  final String? time;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ServerPublishData(
      {required this.id,
      this.programName,
      this.date,
      required this.disStrategy,
      required this.disType,
      this.invalidTime,
      this.makeTime,
      required this.playMode,
      required this.proId,
      required this.proType,
      required this.publisher,
      required this.terminalId,
      this.time,
      required this.type,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || programName != null) {
      map['program_name'] = Variable<String>(programName);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    map['dis_strategy'] = Variable<String>(disStrategy);
    map['dis_type'] = Variable<String>(disType);
    if (!nullToAbsent || invalidTime != null) {
      map['invalid_time'] = Variable<String>(invalidTime);
    }
    if (!nullToAbsent || makeTime != null) {
      map['make_time'] = Variable<String>(makeTime);
    }
    map['play_mode'] = Variable<String>(playMode);
    map['pro_id'] = Variable<String>(proId);
    map['pro_type'] = Variable<int>(proType);
    map['publisher'] = Variable<String>(publisher);
    map['terminal_id'] = Variable<String>(terminalId);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServerPublishCompanion toCompanion(bool nullToAbsent) {
    return ServerPublishCompanion(
      id: Value(id),
      programName: programName == null && nullToAbsent
          ? const Value.absent()
          : Value(programName),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      disStrategy: Value(disStrategy),
      disType: Value(disType),
      invalidTime: invalidTime == null && nullToAbsent
          ? const Value.absent()
          : Value(invalidTime),
      makeTime: makeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(makeTime),
      playMode: Value(playMode),
      proId: Value(proId),
      proType: Value(proType),
      publisher: Value(publisher),
      terminalId: Value(terminalId),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ServerPublishData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerPublishData(
      id: serializer.fromJson<int>(json['id']),
      programName: serializer.fromJson<String?>(json['programName']),
      date: serializer.fromJson<String?>(json['date']),
      disStrategy: serializer.fromJson<String>(json['disStrategy']),
      disType: serializer.fromJson<String>(json['disType']),
      invalidTime: serializer.fromJson<String?>(json['invalidTime']),
      makeTime: serializer.fromJson<String?>(json['makeTime']),
      playMode: serializer.fromJson<String>(json['playMode']),
      proId: serializer.fromJson<String>(json['proId']),
      proType: serializer.fromJson<int>(json['proType']),
      publisher: serializer.fromJson<String>(json['publisher']),
      terminalId: serializer.fromJson<String>(json['terminalId']),
      time: serializer.fromJson<String?>(json['time']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'programName': serializer.toJson<String?>(programName),
      'date': serializer.toJson<String?>(date),
      'disStrategy': serializer.toJson<String>(disStrategy),
      'disType': serializer.toJson<String>(disType),
      'invalidTime': serializer.toJson<String?>(invalidTime),
      'makeTime': serializer.toJson<String?>(makeTime),
      'playMode': serializer.toJson<String>(playMode),
      'proId': serializer.toJson<String>(proId),
      'proType': serializer.toJson<int>(proType),
      'publisher': serializer.toJson<String>(publisher),
      'terminalId': serializer.toJson<String>(terminalId),
      'time': serializer.toJson<String?>(time),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ServerPublishData copyWith(
          {int? id,
          Value<String?> programName = const Value.absent(),
          Value<String?> date = const Value.absent(),
          String? disStrategy,
          String? disType,
          Value<String?> invalidTime = const Value.absent(),
          Value<String?> makeTime = const Value.absent(),
          String? playMode,
          String? proId,
          int? proType,
          String? publisher,
          String? terminalId,
          Value<String?> time = const Value.absent(),
          String? type,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ServerPublishData(
        id: id ?? this.id,
        programName: programName.present ? programName.value : this.programName,
        date: date.present ? date.value : this.date,
        disStrategy: disStrategy ?? this.disStrategy,
        disType: disType ?? this.disType,
        invalidTime: invalidTime.present ? invalidTime.value : this.invalidTime,
        makeTime: makeTime.present ? makeTime.value : this.makeTime,
        playMode: playMode ?? this.playMode,
        proId: proId ?? this.proId,
        proType: proType ?? this.proType,
        publisher: publisher ?? this.publisher,
        terminalId: terminalId ?? this.terminalId,
        time: time.present ? time.value : this.time,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ServerPublishData copyWithCompanion(ServerPublishCompanion data) {
    return ServerPublishData(
      id: data.id.present ? data.id.value : this.id,
      programName:
          data.programName.present ? data.programName.value : this.programName,
      date: data.date.present ? data.date.value : this.date,
      disStrategy:
          data.disStrategy.present ? data.disStrategy.value : this.disStrategy,
      disType: data.disType.present ? data.disType.value : this.disType,
      invalidTime:
          data.invalidTime.present ? data.invalidTime.value : this.invalidTime,
      makeTime: data.makeTime.present ? data.makeTime.value : this.makeTime,
      playMode: data.playMode.present ? data.playMode.value : this.playMode,
      proId: data.proId.present ? data.proId.value : this.proId,
      proType: data.proType.present ? data.proType.value : this.proType,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      terminalId:
          data.terminalId.present ? data.terminalId.value : this.terminalId,
      time: data.time.present ? data.time.value : this.time,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerPublishData(')
          ..write('id: $id, ')
          ..write('programName: $programName, ')
          ..write('date: $date, ')
          ..write('disStrategy: $disStrategy, ')
          ..write('disType: $disType, ')
          ..write('invalidTime: $invalidTime, ')
          ..write('makeTime: $makeTime, ')
          ..write('playMode: $playMode, ')
          ..write('proId: $proId, ')
          ..write('proType: $proType, ')
          ..write('publisher: $publisher, ')
          ..write('terminalId: $terminalId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      programName,
      date,
      disStrategy,
      disType,
      invalidTime,
      makeTime,
      playMode,
      proId,
      proType,
      publisher,
      terminalId,
      time,
      type,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerPublishData &&
          other.id == this.id &&
          other.programName == this.programName &&
          other.date == this.date &&
          other.disStrategy == this.disStrategy &&
          other.disType == this.disType &&
          other.invalidTime == this.invalidTime &&
          other.makeTime == this.makeTime &&
          other.playMode == this.playMode &&
          other.proId == this.proId &&
          other.proType == this.proType &&
          other.publisher == this.publisher &&
          other.terminalId == this.terminalId &&
          other.time == this.time &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServerPublishCompanion extends UpdateCompanion<ServerPublishData> {
  final Value<int> id;
  final Value<String?> programName;
  final Value<String?> date;
  final Value<String> disStrategy;
  final Value<String> disType;
  final Value<String?> invalidTime;
  final Value<String?> makeTime;
  final Value<String> playMode;
  final Value<String> proId;
  final Value<int> proType;
  final Value<String> publisher;
  final Value<String> terminalId;
  final Value<String?> time;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ServerPublishCompanion({
    this.id = const Value.absent(),
    this.programName = const Value.absent(),
    this.date = const Value.absent(),
    this.disStrategy = const Value.absent(),
    this.disType = const Value.absent(),
    this.invalidTime = const Value.absent(),
    this.makeTime = const Value.absent(),
    this.playMode = const Value.absent(),
    this.proId = const Value.absent(),
    this.proType = const Value.absent(),
    this.publisher = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ServerPublishCompanion.insert({
    this.id = const Value.absent(),
    this.programName = const Value.absent(),
    this.date = const Value.absent(),
    this.disStrategy = const Value.absent(),
    this.disType = const Value.absent(),
    this.invalidTime = const Value.absent(),
    this.makeTime = const Value.absent(),
    this.playMode = const Value.absent(),
    this.proId = const Value.absent(),
    this.proType = const Value.absent(),
    this.publisher = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<ServerPublishData> custom({
    Expression<int>? id,
    Expression<String>? programName,
    Expression<String>? date,
    Expression<String>? disStrategy,
    Expression<String>? disType,
    Expression<String>? invalidTime,
    Expression<String>? makeTime,
    Expression<String>? playMode,
    Expression<String>? proId,
    Expression<int>? proType,
    Expression<String>? publisher,
    Expression<String>? terminalId,
    Expression<String>? time,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programName != null) 'program_name': programName,
      if (date != null) 'date': date,
      if (disStrategy != null) 'dis_strategy': disStrategy,
      if (disType != null) 'dis_type': disType,
      if (invalidTime != null) 'invalid_time': invalidTime,
      if (makeTime != null) 'make_time': makeTime,
      if (playMode != null) 'play_mode': playMode,
      if (proId != null) 'pro_id': proId,
      if (proType != null) 'pro_type': proType,
      if (publisher != null) 'publisher': publisher,
      if (terminalId != null) 'terminal_id': terminalId,
      if (time != null) 'time': time,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ServerPublishCompanion copyWith(
      {Value<int>? id,
      Value<String?>? programName,
      Value<String?>? date,
      Value<String>? disStrategy,
      Value<String>? disType,
      Value<String?>? invalidTime,
      Value<String?>? makeTime,
      Value<String>? playMode,
      Value<String>? proId,
      Value<int>? proType,
      Value<String>? publisher,
      Value<String>? terminalId,
      Value<String?>? time,
      Value<String>? type,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ServerPublishCompanion(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      date: date ?? this.date,
      disStrategy: disStrategy ?? this.disStrategy,
      disType: disType ?? this.disType,
      invalidTime: invalidTime ?? this.invalidTime,
      makeTime: makeTime ?? this.makeTime,
      playMode: playMode ?? this.playMode,
      proId: proId ?? this.proId,
      proType: proType ?? this.proType,
      publisher: publisher ?? this.publisher,
      terminalId: terminalId ?? this.terminalId,
      time: time ?? this.time,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (programName.present) {
      map['program_name'] = Variable<String>(programName.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (disStrategy.present) {
      map['dis_strategy'] = Variable<String>(disStrategy.value);
    }
    if (disType.present) {
      map['dis_type'] = Variable<String>(disType.value);
    }
    if (invalidTime.present) {
      map['invalid_time'] = Variable<String>(invalidTime.value);
    }
    if (makeTime.present) {
      map['make_time'] = Variable<String>(makeTime.value);
    }
    if (playMode.present) {
      map['play_mode'] = Variable<String>(playMode.value);
    }
    if (proId.present) {
      map['pro_id'] = Variable<String>(proId.value);
    }
    if (proType.present) {
      map['pro_type'] = Variable<int>(proType.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<String>(terminalId.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerPublishCompanion(')
          ..write('id: $id, ')
          ..write('programName: $programName, ')
          ..write('date: $date, ')
          ..write('disStrategy: $disStrategy, ')
          ..write('disType: $disType, ')
          ..write('invalidTime: $invalidTime, ')
          ..write('makeTime: $makeTime, ')
          ..write('playMode: $playMode, ')
          ..write('proId: $proId, ')
          ..write('proType: $proType, ')
          ..write('publisher: $publisher, ')
          ..write('terminalId: $terminalId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OperationRecordsTable extends OperationRecords
    with TableInfo<$OperationRecordsTable, OperationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperationRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operationDetailMeta =
      const VerificationMeta('operationDetail');
  @override
  late final GeneratedColumn<String> operationDetail = GeneratedColumn<String>(
      'operation_detail', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationTimeMeta =
      const VerificationMeta('operationTime');
  @override
  late final GeneratedColumn<DateTime> operationTime =
      GeneratedColumn<DateTime>('operation_time', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userName, userId, operationDetail, operationTime, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operation_records';
  @override
  VerificationContext validateIntegrity(Insertable<OperationRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('operation_detail')) {
      context.handle(
          _operationDetailMeta,
          operationDetail.isAcceptableOrUnknown(
              data['operation_detail']!, _operationDetailMeta));
    } else if (isInserting) {
      context.missing(_operationDetailMeta);
    }
    if (data.containsKey('operation_time')) {
      context.handle(
          _operationTimeMeta,
          operationTime.isAcceptableOrUnknown(
              data['operation_time']!, _operationTimeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperationRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      operationDetail: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}operation_detail'])!,
      operationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}operation_time'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OperationRecordsTable createAlias(String alias) {
    return $OperationRecordsTable(attachedDatabase, alias);
  }
}

class OperationRecord extends DataClass implements Insertable<OperationRecord> {
  final int id;
  final String userName;
  final int userId;
  final String operationDetail;
  final DateTime operationTime;
  final DateTime createdAt;
  const OperationRecord(
      {required this.id,
      required this.userName,
      required this.userId,
      required this.operationDetail,
      required this.operationTime,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['user_id'] = Variable<int>(userId);
    map['operation_detail'] = Variable<String>(operationDetail);
    map['operation_time'] = Variable<DateTime>(operationTime);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OperationRecordsCompanion toCompanion(bool nullToAbsent) {
    return OperationRecordsCompanion(
      id: Value(id),
      userName: Value(userName),
      userId: Value(userId),
      operationDetail: Value(operationDetail),
      operationTime: Value(operationTime),
      createdAt: Value(createdAt),
    );
  }

  factory OperationRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperationRecord(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      userId: serializer.fromJson<int>(json['userId']),
      operationDetail: serializer.fromJson<String>(json['operationDetail']),
      operationTime: serializer.fromJson<DateTime>(json['operationTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'userId': serializer.toJson<int>(userId),
      'operationDetail': serializer.toJson<String>(operationDetail),
      'operationTime': serializer.toJson<DateTime>(operationTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OperationRecord copyWith(
          {int? id,
          String? userName,
          int? userId,
          String? operationDetail,
          DateTime? operationTime,
          DateTime? createdAt}) =>
      OperationRecord(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        userId: userId ?? this.userId,
        operationDetail: operationDetail ?? this.operationDetail,
        operationTime: operationTime ?? this.operationTime,
        createdAt: createdAt ?? this.createdAt,
      );
  OperationRecord copyWithCompanion(OperationRecordsCompanion data) {
    return OperationRecord(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      userId: data.userId.present ? data.userId.value : this.userId,
      operationDetail: data.operationDetail.present
          ? data.operationDetail.value
          : this.operationDetail,
      operationTime: data.operationTime.present
          ? data.operationTime.value
          : this.operationTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperationRecord(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('userId: $userId, ')
          ..write('operationDetail: $operationDetail, ')
          ..write('operationTime: $operationTime, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userName, userId, operationDetail, operationTime, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperationRecord &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.userId == this.userId &&
          other.operationDetail == this.operationDetail &&
          other.operationTime == this.operationTime &&
          other.createdAt == this.createdAt);
}

class OperationRecordsCompanion extends UpdateCompanion<OperationRecord> {
  final Value<int> id;
  final Value<String> userName;
  final Value<int> userId;
  final Value<String> operationDetail;
  final Value<DateTime> operationTime;
  final Value<DateTime> createdAt;
  const OperationRecordsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.userId = const Value.absent(),
    this.operationDetail = const Value.absent(),
    this.operationTime = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OperationRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userName,
    required int userId,
    required String operationDetail,
    this.operationTime = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userName = Value(userName),
        userId = Value(userId),
        operationDetail = Value(operationDetail);
  static Insertable<OperationRecord> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<int>? userId,
    Expression<String>? operationDetail,
    Expression<DateTime>? operationTime,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (userId != null) 'user_id': userId,
      if (operationDetail != null) 'operation_detail': operationDetail,
      if (operationTime != null) 'operation_time': operationTime,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OperationRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? userName,
      Value<int>? userId,
      Value<String>? operationDetail,
      Value<DateTime>? operationTime,
      Value<DateTime>? createdAt}) {
    return OperationRecordsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      operationDetail: operationDetail ?? this.operationDetail,
      operationTime: operationTime ?? this.operationTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (operationDetail.present) {
      map['operation_detail'] = Variable<String>(operationDetail.value);
    }
    if (operationTime.present) {
      map['operation_time'] = Variable<DateTime>(operationTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperationRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('userId: $userId, ')
          ..write('operationDetail: $operationDetail, ')
          ..write('operationTime: $operationTime, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TemplatesGroupTable templatesGroup = $TemplatesGroupTable(this);
  late final $ResourceTypeTable resourceType = $ResourceTypeTable(this);
  late final $ResourceGroupTable resourceGroup = $ResourceGroupTable(this);
  late final $ResourceTable resource = $ResourceTable(this);
  late final $TerminalGroupTable terminalGroup = $TerminalGroupTable(this);
  late final $TerminalTable terminal = $TerminalTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $TemplateItemsTable templateItems = $TemplateItemsTable(this);
  late final $CmdInfoTable cmdInfo = $CmdInfoTable(this);
  late final $ProgramGroupTable programGroup = $ProgramGroupTable(this);
  late final $ProgramTable program = $ProgramTable(this);
  late final $ProgramItemsTable programItems = $ProgramItemsTable(this);
  late final $ServerPublishTable serverPublish = $ServerPublishTable(this);
  late final $OperationRecordsTable operationRecords =
      $OperationRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        templatesGroup,
        resourceType,
        resourceGroup,
        resource,
        terminalGroup,
        terminal,
        templates,
        templateItems,
        cmdInfo,
        programGroup,
        program,
        programItems,
        serverPublish,
        operationRecords
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String password,
  Value<String?> securityQuestion,
  Value<String?> securityAnswer,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> password,
  Value<String?> securityQuestion,
  Value<String?> securityAnswer,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get securityQuestion => $composableBuilder(
      column: $table.securityQuestion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get securityAnswer => $composableBuilder(
      column: $table.securityAnswer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get securityQuestion => $composableBuilder(
      column: $table.securityQuestion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get securityAnswer => $composableBuilder(
      column: $table.securityAnswer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get securityQuestion => $composableBuilder(
      column: $table.securityQuestion, builder: (column) => column);

  GeneratedColumn<String> get securityAnswer => $composableBuilder(
      column: $table.securityAnswer, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String?> securityQuestion = const Value.absent(),
            Value<String?> securityAnswer = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            password: password,
            securityQuestion: securityQuestion,
            securityAnswer: securityAnswer,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String password,
            Value<String?> securityQuestion = const Value.absent(),
            Value<String?> securityAnswer = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            password: password,
            securityQuestion: securityQuestion,
            securityAnswer: securityAnswer,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$TemplatesGroupTableCreateCompanionBuilder = TemplatesGroupCompanion
    Function({
  Value<int> id,
  required String label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TemplatesGroupTableUpdateCompanionBuilder = TemplatesGroupCompanion
    Function({
  Value<int> id,
  Value<String> label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$TemplatesGroupTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesGroupTable> {
  $$TemplatesGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TemplatesGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesGroupTable> {
  $$TemplatesGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TemplatesGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesGroupTable> {
  $$TemplatesGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get fatherId =>
      $composableBuilder(column: $table.fatherId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TemplatesGroupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemplatesGroupTable,
    TemplatesGroupData,
    $$TemplatesGroupTableFilterComposer,
    $$TemplatesGroupTableOrderingComposer,
    $$TemplatesGroupTableAnnotationComposer,
    $$TemplatesGroupTableCreateCompanionBuilder,
    $$TemplatesGroupTableUpdateCompanionBuilder,
    (
      TemplatesGroupData,
      BaseReferences<_$AppDatabase, $TemplatesGroupTable, TemplatesGroupData>
    ),
    TemplatesGroupData,
    PrefetchHooks Function()> {
  $$TemplatesGroupTableTableManager(
      _$AppDatabase db, $TemplatesGroupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TemplatesGroupCompanion(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String label,
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TemplatesGroupCompanion.insert(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TemplatesGroupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemplatesGroupTable,
    TemplatesGroupData,
    $$TemplatesGroupTableFilterComposer,
    $$TemplatesGroupTableOrderingComposer,
    $$TemplatesGroupTableAnnotationComposer,
    $$TemplatesGroupTableCreateCompanionBuilder,
    $$TemplatesGroupTableUpdateCompanionBuilder,
    (
      TemplatesGroupData,
      BaseReferences<_$AppDatabase, $TemplatesGroupTable, TemplatesGroupData>
    ),
    TemplatesGroupData,
    PrefetchHooks Function()>;
typedef $$ResourceTypeTableCreateCompanionBuilder = ResourceTypeCompanion
    Function({
  Value<int> id,
  required String type,
  required String label,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ResourceTypeTableUpdateCompanionBuilder = ResourceTypeCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<String> label,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ResourceTypeTableFilterComposer
    extends Composer<_$AppDatabase, $ResourceTypeTable> {
  $$ResourceTypeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ResourceTypeTableOrderingComposer
    extends Composer<_$AppDatabase, $ResourceTypeTable> {
  $$ResourceTypeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ResourceTypeTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResourceTypeTable> {
  $$ResourceTypeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ResourceTypeTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResourceTypeTable,
    ResourceTypeData,
    $$ResourceTypeTableFilterComposer,
    $$ResourceTypeTableOrderingComposer,
    $$ResourceTypeTableAnnotationComposer,
    $$ResourceTypeTableCreateCompanionBuilder,
    $$ResourceTypeTableUpdateCompanionBuilder,
    (
      ResourceTypeData,
      BaseReferences<_$AppDatabase, $ResourceTypeTable, ResourceTypeData>
    ),
    ResourceTypeData,
    PrefetchHooks Function()> {
  $$ResourceTypeTableTableManager(_$AppDatabase db, $ResourceTypeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResourceTypeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResourceTypeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResourceTypeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceTypeCompanion(
            id: id,
            type: type,
            label: label,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String label,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceTypeCompanion.insert(
            id: id,
            type: type,
            label: label,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResourceTypeTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResourceTypeTable,
    ResourceTypeData,
    $$ResourceTypeTableFilterComposer,
    $$ResourceTypeTableOrderingComposer,
    $$ResourceTypeTableAnnotationComposer,
    $$ResourceTypeTableCreateCompanionBuilder,
    $$ResourceTypeTableUpdateCompanionBuilder,
    (
      ResourceTypeData,
      BaseReferences<_$AppDatabase, $ResourceTypeTable, ResourceTypeData>
    ),
    ResourceTypeData,
    PrefetchHooks Function()>;
typedef $$ResourceGroupTableCreateCompanionBuilder = ResourceGroupCompanion
    Function({
  Value<int> id,
  required String type,
  required String groupName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ResourceGroupTableUpdateCompanionBuilder = ResourceGroupCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<String> groupName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ResourceGroupTableFilterComposer
    extends Composer<_$AppDatabase, $ResourceGroupTable> {
  $$ResourceGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ResourceGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $ResourceGroupTable> {
  $$ResourceGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ResourceGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResourceGroupTable> {
  $$ResourceGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ResourceGroupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResourceGroupTable,
    ResourceGroupData,
    $$ResourceGroupTableFilterComposer,
    $$ResourceGroupTableOrderingComposer,
    $$ResourceGroupTableAnnotationComposer,
    $$ResourceGroupTableCreateCompanionBuilder,
    $$ResourceGroupTableUpdateCompanionBuilder,
    (
      ResourceGroupData,
      BaseReferences<_$AppDatabase, $ResourceGroupTable, ResourceGroupData>
    ),
    ResourceGroupData,
    PrefetchHooks Function()> {
  $$ResourceGroupTableTableManager(_$AppDatabase db, $ResourceGroupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResourceGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResourceGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResourceGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> groupName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceGroupCompanion(
            id: id,
            type: type,
            groupName: groupName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String groupName,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceGroupCompanion.insert(
            id: id,
            type: type,
            groupName: groupName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResourceGroupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResourceGroupTable,
    ResourceGroupData,
    $$ResourceGroupTableFilterComposer,
    $$ResourceGroupTableOrderingComposer,
    $$ResourceGroupTableAnnotationComposer,
    $$ResourceGroupTableCreateCompanionBuilder,
    $$ResourceGroupTableUpdateCompanionBuilder,
    (
      ResourceGroupData,
      BaseReferences<_$AppDatabase, $ResourceGroupTable, ResourceGroupData>
    ),
    ResourceGroupData,
    PrefetchHooks Function()>;
typedef $$ResourceTableCreateCompanionBuilder = ResourceCompanion Function({
  Value<int> id,
  Value<int?> groupId,
  required String type,
  required String name,
  required String url,
  required String thumbnail,
  Value<int> fileSize,
  required String showFileSize,
  required String localFilePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ResourceTableUpdateCompanionBuilder = ResourceCompanion Function({
  Value<int> id,
  Value<int?> groupId,
  Value<String> type,
  Value<String> name,
  Value<String> url,
  Value<String> thumbnail,
  Value<int> fileSize,
  Value<String> showFileSize,
  Value<String> localFilePath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ResourceTableFilterComposer
    extends Composer<_$AppDatabase, $ResourceTable> {
  $$ResourceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnail => $composableBuilder(
      column: $table.thumbnail, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get showFileSize => $composableBuilder(
      column: $table.showFileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ResourceTableOrderingComposer
    extends Composer<_$AppDatabase, $ResourceTable> {
  $$ResourceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnail => $composableBuilder(
      column: $table.thumbnail, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get showFileSize => $composableBuilder(
      column: $table.showFileSize,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ResourceTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResourceTable> {
  $$ResourceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get thumbnail =>
      $composableBuilder(column: $table.thumbnail, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get showFileSize => $composableBuilder(
      column: $table.showFileSize, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
      column: $table.localFilePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ResourceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResourceTable,
    ResourceData,
    $$ResourceTableFilterComposer,
    $$ResourceTableOrderingComposer,
    $$ResourceTableAnnotationComposer,
    $$ResourceTableCreateCompanionBuilder,
    $$ResourceTableUpdateCompanionBuilder,
    (ResourceData, BaseReferences<_$AppDatabase, $ResourceTable, ResourceData>),
    ResourceData,
    PrefetchHooks Function()> {
  $$ResourceTableTableManager(_$AppDatabase db, $ResourceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResourceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResourceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResourceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> thumbnail = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> showFileSize = const Value.absent(),
            Value<String> localFilePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceCompanion(
            id: id,
            groupId: groupId,
            type: type,
            name: name,
            url: url,
            thumbnail: thumbnail,
            fileSize: fileSize,
            showFileSize: showFileSize,
            localFilePath: localFilePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            required String type,
            required String name,
            required String url,
            required String thumbnail,
            Value<int> fileSize = const Value.absent(),
            required String showFileSize,
            required String localFilePath,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ResourceCompanion.insert(
            id: id,
            groupId: groupId,
            type: type,
            name: name,
            url: url,
            thumbnail: thumbnail,
            fileSize: fileSize,
            showFileSize: showFileSize,
            localFilePath: localFilePath,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResourceTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResourceTable,
    ResourceData,
    $$ResourceTableFilterComposer,
    $$ResourceTableOrderingComposer,
    $$ResourceTableAnnotationComposer,
    $$ResourceTableCreateCompanionBuilder,
    $$ResourceTableUpdateCompanionBuilder,
    (ResourceData, BaseReferences<_$AppDatabase, $ResourceTable, ResourceData>),
    ResourceData,
    PrefetchHooks Function()>;
typedef $$TerminalGroupTableCreateCompanionBuilder = TerminalGroupCompanion
    Function({
  Value<int> id,
  required String label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TerminalGroupTableUpdateCompanionBuilder = TerminalGroupCompanion
    Function({
  Value<int> id,
  Value<String> label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$TerminalGroupTableFilterComposer
    extends Composer<_$AppDatabase, $TerminalGroupTable> {
  $$TerminalGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TerminalGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $TerminalGroupTable> {
  $$TerminalGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TerminalGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $TerminalGroupTable> {
  $$TerminalGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get fatherId =>
      $composableBuilder(column: $table.fatherId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TerminalGroupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TerminalGroupTable,
    TerminalGroupData,
    $$TerminalGroupTableFilterComposer,
    $$TerminalGroupTableOrderingComposer,
    $$TerminalGroupTableAnnotationComposer,
    $$TerminalGroupTableCreateCompanionBuilder,
    $$TerminalGroupTableUpdateCompanionBuilder,
    (
      TerminalGroupData,
      BaseReferences<_$AppDatabase, $TerminalGroupTable, TerminalGroupData>
    ),
    TerminalGroupData,
    PrefetchHooks Function()> {
  $$TerminalGroupTableTableManager(_$AppDatabase db, $TerminalGroupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TerminalGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TerminalGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TerminalGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TerminalGroupCompanion(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String label,
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TerminalGroupCompanion.insert(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TerminalGroupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TerminalGroupTable,
    TerminalGroupData,
    $$TerminalGroupTableFilterComposer,
    $$TerminalGroupTableOrderingComposer,
    $$TerminalGroupTableAnnotationComposer,
    $$TerminalGroupTableCreateCompanionBuilder,
    $$TerminalGroupTableUpdateCompanionBuilder,
    (
      TerminalGroupData,
      BaseReferences<_$AppDatabase, $TerminalGroupTable, TerminalGroupData>
    ),
    TerminalGroupData,
    PrefetchHooks Function()>;
typedef $$TerminalTableCreateCompanionBuilder = TerminalCompanion Function({
  Value<int> id,
  required String name,
  required String terminalCode,
  required String type,
  required String pasWord,
  required String resolution,
  required String sversion,
  required String version,
  required String mac,
  required String status,
  required String updateTime,
  required String lastControlMsg,
  Value<int> groupId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TerminalTableUpdateCompanionBuilder = TerminalCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> terminalCode,
  Value<String> type,
  Value<String> pasWord,
  Value<String> resolution,
  Value<String> sversion,
  Value<String> version,
  Value<String> mac,
  Value<String> status,
  Value<String> updateTime,
  Value<String> lastControlMsg,
  Value<int> groupId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$TerminalTableFilterComposer
    extends Composer<_$AppDatabase, $TerminalTable> {
  $$TerminalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get terminalCode => $composableBuilder(
      column: $table.terminalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pasWord => $composableBuilder(
      column: $table.pasWord, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sversion => $composableBuilder(
      column: $table.sversion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updateTime => $composableBuilder(
      column: $table.updateTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastControlMsg => $composableBuilder(
      column: $table.lastControlMsg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TerminalTableOrderingComposer
    extends Composer<_$AppDatabase, $TerminalTable> {
  $$TerminalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get terminalCode => $composableBuilder(
      column: $table.terminalCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pasWord => $composableBuilder(
      column: $table.pasWord, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sversion => $composableBuilder(
      column: $table.sversion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updateTime => $composableBuilder(
      column: $table.updateTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastControlMsg => $composableBuilder(
      column: $table.lastControlMsg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TerminalTableAnnotationComposer
    extends Composer<_$AppDatabase, $TerminalTable> {
  $$TerminalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get terminalCode => $composableBuilder(
      column: $table.terminalCode, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get pasWord =>
      $composableBuilder(column: $table.pasWord, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<String> get sversion =>
      $composableBuilder(column: $table.sversion, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get updateTime => $composableBuilder(
      column: $table.updateTime, builder: (column) => column);

  GeneratedColumn<String> get lastControlMsg => $composableBuilder(
      column: $table.lastControlMsg, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TerminalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TerminalTable,
    TerminalData,
    $$TerminalTableFilterComposer,
    $$TerminalTableOrderingComposer,
    $$TerminalTableAnnotationComposer,
    $$TerminalTableCreateCompanionBuilder,
    $$TerminalTableUpdateCompanionBuilder,
    (TerminalData, BaseReferences<_$AppDatabase, $TerminalTable, TerminalData>),
    TerminalData,
    PrefetchHooks Function()> {
  $$TerminalTableTableManager(_$AppDatabase db, $TerminalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TerminalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TerminalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TerminalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> terminalCode = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> pasWord = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<String> sversion = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> mac = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> updateTime = const Value.absent(),
            Value<String> lastControlMsg = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TerminalCompanion(
            id: id,
            name: name,
            terminalCode: terminalCode,
            type: type,
            pasWord: pasWord,
            resolution: resolution,
            sversion: sversion,
            version: version,
            mac: mac,
            status: status,
            updateTime: updateTime,
            lastControlMsg: lastControlMsg,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String terminalCode,
            required String type,
            required String pasWord,
            required String resolution,
            required String sversion,
            required String version,
            required String mac,
            required String status,
            required String updateTime,
            required String lastControlMsg,
            Value<int> groupId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TerminalCompanion.insert(
            id: id,
            name: name,
            terminalCode: terminalCode,
            type: type,
            pasWord: pasWord,
            resolution: resolution,
            sversion: sversion,
            version: version,
            mac: mac,
            status: status,
            updateTime: updateTime,
            lastControlMsg: lastControlMsg,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TerminalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TerminalTable,
    TerminalData,
    $$TerminalTableFilterComposer,
    $$TerminalTableOrderingComposer,
    $$TerminalTableAnnotationComposer,
    $$TerminalTableCreateCompanionBuilder,
    $$TerminalTableUpdateCompanionBuilder,
    (TerminalData, BaseReferences<_$AppDatabase, $TerminalTable, TerminalData>),
    TerminalData,
    PrefetchHooks Function()>;
typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  Value<int> id,
  Value<String?> body,
  required String creator,
  Value<String?> desc,
  required int groupId,
  required String resolution,
  required int width,
  required int height,
  required String name,
  Value<String?> preview,
  required String terminalType,
  required String type,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<int> id,
  Value<String?> body,
  Value<String> creator,
  Value<String?> desc,
  Value<int> groupId,
  Value<String> resolution,
  Value<int> width,
  Value<int> height,
  Value<String> name,
  Value<String?> preview,
  Value<String> terminalType,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, Template> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TemplateItemsTable, List<TemplateItem>>
      _templateItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.templateItems,
              aliasName: $_aliasNameGenerator(
                  db.templates.id, db.templateItems.templateId));

  $$TemplateItemsTableProcessedTableManager get templateItemsRefs {
    final manager = $$TemplateItemsTableTableManager($_db, $_db.templateItems)
        .filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_templateItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preview => $composableBuilder(
      column: $table.preview, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get terminalType => $composableBuilder(
      column: $table.terminalType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> templateItemsRefs(
      Expression<bool> Function($$TemplateItemsTableFilterComposer f) f) {
    final $$TemplateItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.templateItems,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplateItemsTableFilterComposer(
              $db: $db,
              $table: $db.templateItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preview => $composableBuilder(
      column: $table.preview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get terminalType => $composableBuilder(
      column: $table.terminalType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get desc =>
      $composableBuilder(column: $table.desc, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get resolution => $composableBuilder(
      column: $table.resolution, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get preview =>
      $composableBuilder(column: $table.preview, builder: (column) => column);

  GeneratedColumn<String> get terminalType => $composableBuilder(
      column: $table.terminalType, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> templateItemsRefs<T extends Object>(
      Expression<T> Function($$TemplateItemsTableAnnotationComposer a) f) {
    final $$TemplateItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.templateItems,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplateItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.templateItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemplatesTable,
    Template,
    $$TemplatesTableFilterComposer,
    $$TemplatesTableOrderingComposer,
    $$TemplatesTableAnnotationComposer,
    $$TemplatesTableCreateCompanionBuilder,
    $$TemplatesTableUpdateCompanionBuilder,
    (Template, $$TemplatesTableReferences),
    Template,
    PrefetchHooks Function({bool templateItemsRefs})> {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String> creator = const Value.absent(),
            Value<String?> desc = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> resolution = const Value.absent(),
            Value<int> width = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> preview = const Value.absent(),
            Value<String> terminalType = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TemplatesCompanion(
            id: id,
            body: body,
            creator: creator,
            desc: desc,
            groupId: groupId,
            resolution: resolution,
            width: width,
            height: height,
            name: name,
            preview: preview,
            terminalType: terminalType,
            type: type,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> body = const Value.absent(),
            required String creator,
            Value<String?> desc = const Value.absent(),
            required int groupId,
            required String resolution,
            required int width,
            required int height,
            required String name,
            Value<String?> preview = const Value.absent(),
            required String terminalType,
            required String type,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TemplatesCompanion.insert(
            id: id,
            body: body,
            creator: creator,
            desc: desc,
            groupId: groupId,
            resolution: resolution,
            width: width,
            height: height,
            name: name,
            preview: preview,
            terminalType: terminalType,
            type: type,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({templateItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateItemsRefs) db.templateItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateItemsRefs)
                    await $_getPrefetchedData<Template, $TemplatesTable,
                            TemplateItem>(
                        currentTable: table,
                        referencedTable: $$TemplatesTableReferences
                            ._templateItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TemplatesTableReferences(db, table, p0)
                                .templateItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemplatesTable,
    Template,
    $$TemplatesTableFilterComposer,
    $$TemplatesTableOrderingComposer,
    $$TemplatesTableAnnotationComposer,
    $$TemplatesTableCreateCompanionBuilder,
    $$TemplatesTableUpdateCompanionBuilder,
    (Template, $$TemplatesTableReferences),
    Template,
    PrefetchHooks Function({bool templateItemsRefs})>;
typedef $$TemplateItemsTableCreateCompanionBuilder = TemplateItemsCompanion
    Function({
  required String id,
  Value<int?> templateId,
  Value<String?> backGround,
  Value<String?> resourceId,
  required double height,
  required String name,
  required String type,
  required double width,
  required int x,
  required int y,
  required int zIndex,
  Value<int> rowid,
});
typedef $$TemplateItemsTableUpdateCompanionBuilder = TemplateItemsCompanion
    Function({
  Value<String> id,
  Value<int?> templateId,
  Value<String?> backGround,
  Value<String?> resourceId,
  Value<double> height,
  Value<String> name,
  Value<String> type,
  Value<double> width,
  Value<int> x,
  Value<int> y,
  Value<int> zIndex,
  Value<int> rowid,
});

final class $$TemplateItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TemplateItemsTable, TemplateItem> {
  $$TemplateItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias(
          $_aliasNameGenerator(db.templateItems.templateId, db.templates.id));

  $$TemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<int>('template_id');
    if ($_column == null) return null;
    final manager = $$TemplatesTableTableManager($_db, $_db.templates)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TemplateItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backGround => $composableBuilder(
      column: $table.backGround, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get zIndex => $composableBuilder(
      column: $table.zIndex, builder: (column) => ColumnFilters(column));

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.templates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplatesTableFilterComposer(
              $db: $db,
              $table: $db.templates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backGround => $composableBuilder(
      column: $table.backGround, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get zIndex => $composableBuilder(
      column: $table.zIndex, builder: (column) => ColumnOrderings(column));

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.templates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.templates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get backGround => $composableBuilder(
      column: $table.backGround, builder: (column) => column);

  GeneratedColumn<String> get resourceId => $composableBuilder(
      column: $table.resourceId, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<int> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<int> get zIndex =>
      $composableBuilder(column: $table.zIndex, builder: (column) => column);

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.templates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.templates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TemplateItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemplateItemsTable,
    TemplateItem,
    $$TemplateItemsTableFilterComposer,
    $$TemplateItemsTableOrderingComposer,
    $$TemplateItemsTableAnnotationComposer,
    $$TemplateItemsTableCreateCompanionBuilder,
    $$TemplateItemsTableUpdateCompanionBuilder,
    (TemplateItem, $$TemplateItemsTableReferences),
    TemplateItem,
    PrefetchHooks Function({bool templateId})> {
  $$TemplateItemsTableTableManager(_$AppDatabase db, $TemplateItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int?> templateId = const Value.absent(),
            Value<String?> backGround = const Value.absent(),
            Value<String?> resourceId = const Value.absent(),
            Value<double> height = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> width = const Value.absent(),
            Value<int> x = const Value.absent(),
            Value<int> y = const Value.absent(),
            Value<int> zIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TemplateItemsCompanion(
            id: id,
            templateId: templateId,
            backGround: backGround,
            resourceId: resourceId,
            height: height,
            name: name,
            type: type,
            width: width,
            x: x,
            y: y,
            zIndex: zIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int?> templateId = const Value.absent(),
            Value<String?> backGround = const Value.absent(),
            Value<String?> resourceId = const Value.absent(),
            required double height,
            required String name,
            required String type,
            required double width,
            required int x,
            required int y,
            required int zIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              TemplateItemsCompanion.insert(
            id: id,
            templateId: templateId,
            backGround: backGround,
            resourceId: resourceId,
            height: height,
            name: name,
            type: type,
            width: width,
            x: x,
            y: y,
            zIndex: zIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TemplateItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$TemplateItemsTableReferences._templateIdTable(db),
                    referencedColumn:
                        $$TemplateItemsTableReferences._templateIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TemplateItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemplateItemsTable,
    TemplateItem,
    $$TemplateItemsTableFilterComposer,
    $$TemplateItemsTableOrderingComposer,
    $$TemplateItemsTableAnnotationComposer,
    $$TemplateItemsTableCreateCompanionBuilder,
    $$TemplateItemsTableUpdateCompanionBuilder,
    (TemplateItem, $$TemplateItemsTableReferences),
    TemplateItem,
    PrefetchHooks Function({bool templateId})>;
typedef $$CmdInfoTableCreateCompanionBuilder = CmdInfoCompanion Function({
  Value<int> id,
  required String pushType,
  Value<int> flag,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CmdInfoTableUpdateCompanionBuilder = CmdInfoCompanion Function({
  Value<int> id,
  Value<String> pushType,
  Value<int> flag,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$CmdInfoTableFilterComposer
    extends Composer<_$AppDatabase, $CmdInfoTable> {
  $$CmdInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pushType => $composableBuilder(
      column: $table.pushType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get flag => $composableBuilder(
      column: $table.flag, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CmdInfoTableOrderingComposer
    extends Composer<_$AppDatabase, $CmdInfoTable> {
  $$CmdInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pushType => $composableBuilder(
      column: $table.pushType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get flag => $composableBuilder(
      column: $table.flag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CmdInfoTableAnnotationComposer
    extends Composer<_$AppDatabase, $CmdInfoTable> {
  $$CmdInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pushType =>
      $composableBuilder(column: $table.pushType, builder: (column) => column);

  GeneratedColumn<int> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CmdInfoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CmdInfoTable,
    CmdInfoData,
    $$CmdInfoTableFilterComposer,
    $$CmdInfoTableOrderingComposer,
    $$CmdInfoTableAnnotationComposer,
    $$CmdInfoTableCreateCompanionBuilder,
    $$CmdInfoTableUpdateCompanionBuilder,
    (CmdInfoData, BaseReferences<_$AppDatabase, $CmdInfoTable, CmdInfoData>),
    CmdInfoData,
    PrefetchHooks Function()> {
  $$CmdInfoTableTableManager(_$AppDatabase db, $CmdInfoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CmdInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CmdInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CmdInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pushType = const Value.absent(),
            Value<int> flag = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CmdInfoCompanion(
            id: id,
            pushType: pushType,
            flag: flag,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pushType,
            Value<int> flag = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CmdInfoCompanion.insert(
            id: id,
            pushType: pushType,
            flag: flag,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CmdInfoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CmdInfoTable,
    CmdInfoData,
    $$CmdInfoTableFilterComposer,
    $$CmdInfoTableOrderingComposer,
    $$CmdInfoTableAnnotationComposer,
    $$CmdInfoTableCreateCompanionBuilder,
    $$CmdInfoTableUpdateCompanionBuilder,
    (CmdInfoData, BaseReferences<_$AppDatabase, $CmdInfoTable, CmdInfoData>),
    CmdInfoData,
    PrefetchHooks Function()>;
typedef $$ProgramGroupTableCreateCompanionBuilder = ProgramGroupCompanion
    Function({
  Value<int> id,
  required String label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProgramGroupTableUpdateCompanionBuilder = ProgramGroupCompanion
    Function({
  Value<int> id,
  Value<String> label,
  Value<int?> fatherId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ProgramGroupTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramGroupTable> {
  $$ProgramGroupTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ProgramGroupTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramGroupTable> {
  $$ProgramGroupTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProgramGroupTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramGroupTable> {
  $$ProgramGroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get fatherId =>
      $composableBuilder(column: $table.fatherId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProgramGroupTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgramGroupTable,
    ProgramGroupData,
    $$ProgramGroupTableFilterComposer,
    $$ProgramGroupTableOrderingComposer,
    $$ProgramGroupTableAnnotationComposer,
    $$ProgramGroupTableCreateCompanionBuilder,
    $$ProgramGroupTableUpdateCompanionBuilder,
    (
      ProgramGroupData,
      BaseReferences<_$AppDatabase, $ProgramGroupTable, ProgramGroupData>
    ),
    ProgramGroupData,
    PrefetchHooks Function()> {
  $$ProgramGroupTableTableManager(_$AppDatabase db, $ProgramGroupTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramGroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramGroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramGroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProgramGroupCompanion(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String label,
            Value<int?> fatherId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProgramGroupCompanion.insert(
            id: id,
            label: label,
            fatherId: fatherId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgramGroupTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgramGroupTable,
    ProgramGroupData,
    $$ProgramGroupTableFilterComposer,
    $$ProgramGroupTableOrderingComposer,
    $$ProgramGroupTableAnnotationComposer,
    $$ProgramGroupTableCreateCompanionBuilder,
    $$ProgramGroupTableUpdateCompanionBuilder,
    (
      ProgramGroupData,
      BaseReferences<_$AppDatabase, $ProgramGroupTable, ProgramGroupData>
    ),
    ProgramGroupData,
    PrefetchHooks Function()>;
typedef $$ProgramTableCreateCompanionBuilder = ProgramCompanion Function({
  Value<int> id,
  required int groupId,
  required int modelId,
  required String name,
  Value<String?> preview,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ProgramTableUpdateCompanionBuilder = ProgramCompanion Function({
  Value<int> id,
  Value<int> groupId,
  Value<int> modelId,
  Value<String> name,
  Value<String?> preview,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ProgramTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramTable, ProgramData> {
  $$ProgramTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProgramItemsTable, List<ProgramItem>>
      _programItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.programItems,
          aliasName:
              $_aliasNameGenerator(db.program.id, db.programItems.programId));

  $$ProgramItemsTableProcessedTableManager get programItemsRefs {
    final manager = $$ProgramItemsTableTableManager($_db, $_db.programItems)
        .filter((f) => f.programId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_programItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProgramTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramTable> {
  $$ProgramTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preview => $composableBuilder(
      column: $table.preview, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> programItemsRefs(
      Expression<bool> Function($$ProgramItemsTableFilterComposer f) f) {
    final $$ProgramItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.programItems,
        getReferencedColumn: (t) => t.programId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgramItemsTableFilterComposer(
              $db: $db,
              $table: $db.programItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProgramTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramTable> {
  $$ProgramTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preview => $composableBuilder(
      column: $table.preview, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProgramTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramTable> {
  $$ProgramTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get preview =>
      $composableBuilder(column: $table.preview, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> programItemsRefs<T extends Object>(
      Expression<T> Function($$ProgramItemsTableAnnotationComposer a) f) {
    final $$ProgramItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.programItems,
        getReferencedColumn: (t) => t.programId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgramItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.programItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProgramTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgramTable,
    ProgramData,
    $$ProgramTableFilterComposer,
    $$ProgramTableOrderingComposer,
    $$ProgramTableAnnotationComposer,
    $$ProgramTableCreateCompanionBuilder,
    $$ProgramTableUpdateCompanionBuilder,
    (ProgramData, $$ProgramTableReferences),
    ProgramData,
    PrefetchHooks Function({bool programItemsRefs})> {
  $$ProgramTableTableManager(_$AppDatabase db, $ProgramTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<int> modelId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> preview = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProgramCompanion(
            id: id,
            groupId: groupId,
            modelId: modelId,
            name: name,
            preview: preview,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int groupId,
            required int modelId,
            required String name,
            Value<String?> preview = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ProgramCompanion.insert(
            id: id,
            groupId: groupId,
            modelId: modelId,
            name: name,
            preview: preview,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProgramTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({programItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (programItemsRefs) db.programItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (programItemsRefs)
                    await $_getPrefetchedData<ProgramData, $ProgramTable,
                            ProgramItem>(
                        currentTable: table,
                        referencedTable:
                            $$ProgramTableReferences._programItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProgramTableReferences(db, table, p0)
                                .programItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.programId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProgramTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgramTable,
    ProgramData,
    $$ProgramTableFilterComposer,
    $$ProgramTableOrderingComposer,
    $$ProgramTableAnnotationComposer,
    $$ProgramTableCreateCompanionBuilder,
    $$ProgramTableUpdateCompanionBuilder,
    (ProgramData, $$ProgramTableReferences),
    ProgramData,
    PrefetchHooks Function({bool programItemsRefs})>;
typedef $$ProgramItemsTableCreateCompanionBuilder = ProgramItemsCompanion
    Function({
  Value<int> id,
  Value<int?> programId,
  required String itemsId,
  required String url,
});
typedef $$ProgramItemsTableUpdateCompanionBuilder = ProgramItemsCompanion
    Function({
  Value<int> id,
  Value<int?> programId,
  Value<String> itemsId,
  Value<String> url,
});

final class $$ProgramItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramItemsTable, ProgramItem> {
  $$ProgramItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProgramTable _programIdTable(_$AppDatabase db) =>
      db.program.createAlias(
          $_aliasNameGenerator(db.programItems.programId, db.program.id));

  $$ProgramTableProcessedTableManager? get programId {
    final $_column = $_itemColumn<int>('program_id');
    if ($_column == null) return null;
    final manager = $$ProgramTableTableManager($_db, $_db.program)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProgramItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramItemsTable> {
  $$ProgramItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsId => $composableBuilder(
      column: $table.itemsId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  $$ProgramTableFilterComposer get programId {
    final $$ProgramTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programId,
        referencedTable: $db.program,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgramTableFilterComposer(
              $db: $db,
              $table: $db.program,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgramItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramItemsTable> {
  $$ProgramItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsId => $composableBuilder(
      column: $table.itemsId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  $$ProgramTableOrderingComposer get programId {
    final $$ProgramTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programId,
        referencedTable: $db.program,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgramTableOrderingComposer(
              $db: $db,
              $table: $db.program,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgramItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramItemsTable> {
  $$ProgramItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemsId =>
      $composableBuilder(column: $table.itemsId, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  $$ProgramTableAnnotationComposer get programId {
    final $$ProgramTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programId,
        referencedTable: $db.program,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgramTableAnnotationComposer(
              $db: $db,
              $table: $db.program,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgramItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgramItemsTable,
    ProgramItem,
    $$ProgramItemsTableFilterComposer,
    $$ProgramItemsTableOrderingComposer,
    $$ProgramItemsTableAnnotationComposer,
    $$ProgramItemsTableCreateCompanionBuilder,
    $$ProgramItemsTableUpdateCompanionBuilder,
    (ProgramItem, $$ProgramItemsTableReferences),
    ProgramItem,
    PrefetchHooks Function({bool programId})> {
  $$ProgramItemsTableTableManager(_$AppDatabase db, $ProgramItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> programId = const Value.absent(),
            Value<String> itemsId = const Value.absent(),
            Value<String> url = const Value.absent(),
          }) =>
              ProgramItemsCompanion(
            id: id,
            programId: programId,
            itemsId: itemsId,
            url: url,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> programId = const Value.absent(),
            required String itemsId,
            required String url,
          }) =>
              ProgramItemsCompanion.insert(
            id: id,
            programId: programId,
            itemsId: itemsId,
            url: url,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProgramItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({programId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (programId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.programId,
                    referencedTable:
                        $$ProgramItemsTableReferences._programIdTable(db),
                    referencedColumn:
                        $$ProgramItemsTableReferences._programIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProgramItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgramItemsTable,
    ProgramItem,
    $$ProgramItemsTableFilterComposer,
    $$ProgramItemsTableOrderingComposer,
    $$ProgramItemsTableAnnotationComposer,
    $$ProgramItemsTableCreateCompanionBuilder,
    $$ProgramItemsTableUpdateCompanionBuilder,
    (ProgramItem, $$ProgramItemsTableReferences),
    ProgramItem,
    PrefetchHooks Function({bool programId})>;
typedef $$ServerPublishTableCreateCompanionBuilder = ServerPublishCompanion
    Function({
  Value<int> id,
  Value<String?> programName,
  Value<String?> date,
  Value<String> disStrategy,
  Value<String> disType,
  Value<String?> invalidTime,
  Value<String?> makeTime,
  Value<String> playMode,
  Value<String> proId,
  Value<int> proType,
  Value<String> publisher,
  Value<String> terminalId,
  Value<String?> time,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ServerPublishTableUpdateCompanionBuilder = ServerPublishCompanion
    Function({
  Value<int> id,
  Value<String?> programName,
  Value<String?> date,
  Value<String> disStrategy,
  Value<String> disType,
  Value<String?> invalidTime,
  Value<String?> makeTime,
  Value<String> playMode,
  Value<String> proId,
  Value<int> proType,
  Value<String> publisher,
  Value<String> terminalId,
  Value<String?> time,
  Value<String> type,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ServerPublishTableFilterComposer
    extends Composer<_$AppDatabase, $ServerPublishTable> {
  $$ServerPublishTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disStrategy => $composableBuilder(
      column: $table.disStrategy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disType => $composableBuilder(
      column: $table.disType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invalidTime => $composableBuilder(
      column: $table.invalidTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get makeTime => $composableBuilder(
      column: $table.makeTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playMode => $composableBuilder(
      column: $table.playMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proId => $composableBuilder(
      column: $table.proId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get proType => $composableBuilder(
      column: $table.proType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get terminalId => $composableBuilder(
      column: $table.terminalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ServerPublishTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerPublishTable> {
  $$ServerPublishTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disStrategy => $composableBuilder(
      column: $table.disStrategy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disType => $composableBuilder(
      column: $table.disType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invalidTime => $composableBuilder(
      column: $table.invalidTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get makeTime => $composableBuilder(
      column: $table.makeTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playMode => $composableBuilder(
      column: $table.playMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proId => $composableBuilder(
      column: $table.proId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get proType => $composableBuilder(
      column: $table.proType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publisher => $composableBuilder(
      column: $table.publisher, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get terminalId => $composableBuilder(
      column: $table.terminalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ServerPublishTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerPublishTable> {
  $$ServerPublishTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programName => $composableBuilder(
      column: $table.programName, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get disStrategy => $composableBuilder(
      column: $table.disStrategy, builder: (column) => column);

  GeneratedColumn<String> get disType =>
      $composableBuilder(column: $table.disType, builder: (column) => column);

  GeneratedColumn<String> get invalidTime => $composableBuilder(
      column: $table.invalidTime, builder: (column) => column);

  GeneratedColumn<String> get makeTime =>
      $composableBuilder(column: $table.makeTime, builder: (column) => column);

  GeneratedColumn<String> get playMode =>
      $composableBuilder(column: $table.playMode, builder: (column) => column);

  GeneratedColumn<String> get proId =>
      $composableBuilder(column: $table.proId, builder: (column) => column);

  GeneratedColumn<int> get proType =>
      $composableBuilder(column: $table.proType, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<String> get terminalId => $composableBuilder(
      column: $table.terminalId, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ServerPublishTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServerPublishTable,
    ServerPublishData,
    $$ServerPublishTableFilterComposer,
    $$ServerPublishTableOrderingComposer,
    $$ServerPublishTableAnnotationComposer,
    $$ServerPublishTableCreateCompanionBuilder,
    $$ServerPublishTableUpdateCompanionBuilder,
    (
      ServerPublishData,
      BaseReferences<_$AppDatabase, $ServerPublishTable, ServerPublishData>
    ),
    ServerPublishData,
    PrefetchHooks Function()> {
  $$ServerPublishTableTableManager(_$AppDatabase db, $ServerPublishTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerPublishTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerPublishTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerPublishTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> programName = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<String> disStrategy = const Value.absent(),
            Value<String> disType = const Value.absent(),
            Value<String?> invalidTime = const Value.absent(),
            Value<String?> makeTime = const Value.absent(),
            Value<String> playMode = const Value.absent(),
            Value<String> proId = const Value.absent(),
            Value<int> proType = const Value.absent(),
            Value<String> publisher = const Value.absent(),
            Value<String> terminalId = const Value.absent(),
            Value<String?> time = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ServerPublishCompanion(
            id: id,
            programName: programName,
            date: date,
            disStrategy: disStrategy,
            disType: disType,
            invalidTime: invalidTime,
            makeTime: makeTime,
            playMode: playMode,
            proId: proId,
            proType: proType,
            publisher: publisher,
            terminalId: terminalId,
            time: time,
            type: type,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> programName = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<String> disStrategy = const Value.absent(),
            Value<String> disType = const Value.absent(),
            Value<String?> invalidTime = const Value.absent(),
            Value<String?> makeTime = const Value.absent(),
            Value<String> playMode = const Value.absent(),
            Value<String> proId = const Value.absent(),
            Value<int> proType = const Value.absent(),
            Value<String> publisher = const Value.absent(),
            Value<String> terminalId = const Value.absent(),
            Value<String?> time = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ServerPublishCompanion.insert(
            id: id,
            programName: programName,
            date: date,
            disStrategy: disStrategy,
            disType: disType,
            invalidTime: invalidTime,
            makeTime: makeTime,
            playMode: playMode,
            proId: proId,
            proType: proType,
            publisher: publisher,
            terminalId: terminalId,
            time: time,
            type: type,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServerPublishTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServerPublishTable,
    ServerPublishData,
    $$ServerPublishTableFilterComposer,
    $$ServerPublishTableOrderingComposer,
    $$ServerPublishTableAnnotationComposer,
    $$ServerPublishTableCreateCompanionBuilder,
    $$ServerPublishTableUpdateCompanionBuilder,
    (
      ServerPublishData,
      BaseReferences<_$AppDatabase, $ServerPublishTable, ServerPublishData>
    ),
    ServerPublishData,
    PrefetchHooks Function()>;
typedef $$OperationRecordsTableCreateCompanionBuilder
    = OperationRecordsCompanion Function({
  Value<int> id,
  required String userName,
  required int userId,
  required String operationDetail,
  Value<DateTime> operationTime,
  Value<DateTime> createdAt,
});
typedef $$OperationRecordsTableUpdateCompanionBuilder
    = OperationRecordsCompanion Function({
  Value<int> id,
  Value<String> userName,
  Value<int> userId,
  Value<String> operationDetail,
  Value<DateTime> operationTime,
  Value<DateTime> createdAt,
});

class $$OperationRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $OperationRecordsTable> {
  $$OperationRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationDetail => $composableBuilder(
      column: $table.operationDetail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get operationTime => $composableBuilder(
      column: $table.operationTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$OperationRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $OperationRecordsTable> {
  $$OperationRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationDetail => $composableBuilder(
      column: $table.operationDetail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get operationTime => $composableBuilder(
      column: $table.operationTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$OperationRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OperationRecordsTable> {
  $$OperationRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get operationDetail => $composableBuilder(
      column: $table.operationDetail, builder: (column) => column);

  GeneratedColumn<DateTime> get operationTime => $composableBuilder(
      column: $table.operationTime, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OperationRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OperationRecordsTable,
    OperationRecord,
    $$OperationRecordsTableFilterComposer,
    $$OperationRecordsTableOrderingComposer,
    $$OperationRecordsTableAnnotationComposer,
    $$OperationRecordsTableCreateCompanionBuilder,
    $$OperationRecordsTableUpdateCompanionBuilder,
    (
      OperationRecord,
      BaseReferences<_$AppDatabase, $OperationRecordsTable, OperationRecord>
    ),
    OperationRecord,
    PrefetchHooks Function()> {
  $$OperationRecordsTableTableManager(
      _$AppDatabase db, $OperationRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperationRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperationRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperationRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> operationDetail = const Value.absent(),
            Value<DateTime> operationTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OperationRecordsCompanion(
            id: id,
            userName: userName,
            userId: userId,
            operationDetail: operationDetail,
            operationTime: operationTime,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userName,
            required int userId,
            required String operationDetail,
            Value<DateTime> operationTime = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OperationRecordsCompanion.insert(
            id: id,
            userName: userName,
            userId: userId,
            operationDetail: operationDetail,
            operationTime: operationTime,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OperationRecordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OperationRecordsTable,
    OperationRecord,
    $$OperationRecordsTableFilterComposer,
    $$OperationRecordsTableOrderingComposer,
    $$OperationRecordsTableAnnotationComposer,
    $$OperationRecordsTableCreateCompanionBuilder,
    $$OperationRecordsTableUpdateCompanionBuilder,
    (
      OperationRecord,
      BaseReferences<_$AppDatabase, $OperationRecordsTable, OperationRecord>
    ),
    OperationRecord,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TemplatesGroupTableTableManager get templatesGroup =>
      $$TemplatesGroupTableTableManager(_db, _db.templatesGroup);
  $$ResourceTypeTableTableManager get resourceType =>
      $$ResourceTypeTableTableManager(_db, _db.resourceType);
  $$ResourceGroupTableTableManager get resourceGroup =>
      $$ResourceGroupTableTableManager(_db, _db.resourceGroup);
  $$ResourceTableTableManager get resource =>
      $$ResourceTableTableManager(_db, _db.resource);
  $$TerminalGroupTableTableManager get terminalGroup =>
      $$TerminalGroupTableTableManager(_db, _db.terminalGroup);
  $$TerminalTableTableManager get terminal =>
      $$TerminalTableTableManager(_db, _db.terminal);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$TemplateItemsTableTableManager get templateItems =>
      $$TemplateItemsTableTableManager(_db, _db.templateItems);
  $$CmdInfoTableTableManager get cmdInfo =>
      $$CmdInfoTableTableManager(_db, _db.cmdInfo);
  $$ProgramGroupTableTableManager get programGroup =>
      $$ProgramGroupTableTableManager(_db, _db.programGroup);
  $$ProgramTableTableManager get program =>
      $$ProgramTableTableManager(_db, _db.program);
  $$ProgramItemsTableTableManager get programItems =>
      $$ProgramItemsTableTableManager(_db, _db.programItems);
  $$ServerPublishTableTableManager get serverPublish =>
      $$ServerPublishTableTableManager(_db, _db.serverPublish);
  $$OperationRecordsTableTableManager get operationRecords =>
      $$OperationRecordsTableTableManager(_db, _db.operationRecords);
}
