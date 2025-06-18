import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'impl/cmdinfo_database.dart';
import 'impl/operationrecords_database.dart';
import 'impl/program_database.dart';
import 'impl/programgroup_database.dart';
import 'impl/resource_database.dart';
import 'impl/resourcetype_database.dart';
import 'impl/serverpublish_database.dart';
import 'impl/tempgroup_database.dart';
import 'impl/templates_database.dart';
import 'impl/terminal_database.dart';
import 'impl/terminalgroup_database.dart';
import 'impl/user_database.dart';

part 'database.g.dart';

// 定义用户表结构
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get username => text().unique()();

  TextColumn get password => text()();

  // 新增：密保问题字段
  TextColumn get securityQuestion => text().nullable()();

  // 新增：密保答案字段
  TextColumn get securityAnswer => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 定义资源类型表结构
class ResourceType extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get type => text().withLength(min: 1, max: 100)();

  TextColumn get label => text().withLength(min: 1, max: 100)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 定义资源分组表结构
class ResourceGroup extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get type => text().withLength(min: 1, max: 100)();

  TextColumn get groupName => text().withLength(min: 1, max: 100)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 定义资源表结构
class Resource extends Table {
  IntColumn get id => integer().autoIncrement()();
  //所属组ID
  IntColumn get groupId => integer().nullable()();
  //资源类型 image,video,audio,rtmp等
  TextColumn get type => text().withLength(min: 1, max: 100)();

  TextColumn get name => text().withLength(min: 1, max: 100)();
  //地址
  TextColumn get url => text().withLength(min: 1, max: 1000)();
  //缩略图
  TextColumn get thumbnail => text().withLength(min: 1, max: 1000)();
  //文件的实际大小
  Column get fileSize => integer().withDefault(const Constant(0))();
  //页面显示的文件大小
  TextColumn get showFileSize => text().withLength(min: 1, max: 100)();

  //本地文件绝对路径
  TextColumn get localFilePath => text().withLength(min: 1, max: 1000)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

//定义模板组表结构
class TemplatesGroup extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text().withLength(min: 1, max: 100)();

  IntColumn get fatherId => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

//终端组表
class TerminalGroup extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text().withLength(min: 1, max: 100)();

  IntColumn get fatherId => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

//终端表
class Terminal extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get terminalCode => text().withLength(min: 1, max: 100)();

  TextColumn get type => text().withLength(min: 1, max: 100)();

  TextColumn get pasWord => text().withLength(max: 100)();

  TextColumn get resolution => text().withLength(min: 1, max: 100)();

  TextColumn get sversion => text().withLength(min: 1, max: 100)();

  TextColumn get version => text().withLength(min: 1, max: 100)();

  TextColumn get mac => text().withLength(min: 1, max: 100)();

  TextColumn get status => text().withLength(min: 1, max: 100)();

  TextColumn get updateTime => text().withLength(min: 1, max: 100)();

  TextColumn get lastControlMsg => text().withLength(min: 1, max: 100)();

  IntColumn get groupId => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 主模板表
class Templates extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  TextColumn get body => text().nullable()();
  TextColumn get creator => text()();
  TextColumn get desc => text().nullable()();
  IntColumn get groupId => integer()();
  TextColumn get resolution => text()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get name => text()();
  TextColumn get preview => text().nullable()();
  TextColumn get terminalType => text()();
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 模板项表
class TemplateItems extends Table {
  TextColumn get id => text()(); // 主键
  IntColumn get templateId =>
      integer().nullable().customConstraint('REFERENCES templates(id)')(); // 外键
  TextColumn get backGround => text().nullable()();
  TextColumn get resourceId => text().nullable()();//资源ID（模板背景图）
  RealColumn get height => real()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get width => real()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  IntColumn get zIndex => integer()();
}

// 节目分组表
class ProgramGroup extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text().withLength(min: 1, max: 100)();
  IntColumn get fatherId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 节目表
class Program extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  IntColumn get groupId => integer()(); //所属节目组id
  IntColumn get modelId => integer()(); //所属模板id
  TextColumn get name => text()(); //节目名字
  TextColumn get preview => text().nullable()(); //节目预览图
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 节目项表
class ProgramItems extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  IntColumn get programId =>
      integer().nullable().customConstraint('REFERENCES program(id)')(); // 外键
  TextColumn get itemsId => text()();
  TextColumn get url => text()();
}

//web端发布的节目表
class ServerPublish extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  TextColumn get programName => text().nullable()();//节目名称
  //播放日期区间  2025-02-13,2025-02-21 （按星期就是0，1，2，3，4，5，6）
  TextColumn get date => text().nullable()();
  //发布策略， overwrite-覆盖  append还是追加
  TextColumn get disStrategy => text().withDefault(const Constant('null'))();
  //发布类型 now-立即发布 plan-预约发布
  TextColumn get disType => text().withDefault(const Constant('null'))();
  //失效时间,停止播放时间
  TextColumn get invalidTime => text().nullable()();
  //预约发布的的发布时间
  TextColumn get makeTime => text().nullable()();
  //播放模式 loop-循环 time-定时播放
  TextColumn get playMode => text().withDefault(const Constant('loop'))();
  //发布的节目ID 多个用空格分开
  TextColumn get proId => text().withDefault(const Constant('0'))();
  //节目类型（暂时无用）
  IntColumn get proType => integer().withDefault(const Constant(1))();
  //发布者
  TextColumn get publisher => text().withDefault(const Constant('admin'))();
  //发布选择的终端id
  TextColumn get terminalId =>  text().withDefault(const Constant('0'))();
  //当天播放的时间
  TextColumn get time => text().nullable()();
  //按星期（week）播放还是日期（date）播放
  TextColumn get type => text().withDefault(const Constant('date'))();
  //创建日期
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  //更新日期
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 心跳推送消息表
class CmdInfo extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get pushType => text().withLength(min: 1, max: 100)(); //推送种类，发布节目

  IntColumn get flag => integer().withDefault(const Constant(0))(); //是否执行完毕

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// 定义操作记录表结构
class OperationRecords extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  TextColumn get userName => text()(); // 用户名
  IntColumn get userId => integer()(); // 用户ID
  TextColumn get operationDetail => text()(); // 操作详情
  DateTimeColumn get operationTime => dateTime().withDefault(currentDateAndTime)(); // 操作时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// 定义数据库类
@DriftDatabase(tables: [
  Users,
  TemplatesGroup,
  ResourceType,
  ResourceGroup,
  Resource,
  TerminalGroup,
  Terminal,
  Templates,
  TemplateItems,
  CmdInfo,
  ProgramGroup,
  Program,
  ProgramItems,
  ServerPublish,
  OperationRecords
])
class AppDatabase extends _$AppDatabase {
  // 实例化用户管理类
  late UserDatabase userDatabase;
  // 实例化用户管理类
  late TempGroupDatabase tempGroupDatabase;
  // 资源类型
  late ResourceTypeDatabase resourceTypeDatabase;
  //资源
  late ResourceDatabase resourceDatabase;
  //终端组
  late TerminalGroupDatabase terminalGroupDatabase;
  //终端
  late TerminalDatabase terminalDatabase;
  //模板表 - 包含模板项
  late TemplatesDatabase templatesDatabase;
  //节目组表
  late ProgramGroupDatabase programGroupDatabase;
  //节目表
  late ProgramDatabase programDatabase;
  //服务端发布节目表
  late ServerPublishDatabase serverPublishDatabase;
  //下发指令表
  late CmdInfoDatabase cmdInfoDatabase;
  //操作记录表
  late OperationRecordsDatabase operationRecordsDatabase;

  AppDatabase() : super(_openConnection()) {
    userDatabase = UserDatabase(this);
    tempGroupDatabase = TempGroupDatabase(this);
    resourceTypeDatabase = ResourceTypeDatabase(this);
    resourceDatabase = ResourceDatabase(this);
    terminalGroupDatabase = TerminalGroupDatabase(this);
    terminalDatabase = TerminalDatabase(this);
    templatesDatabase = TemplatesDatabase(this);
    programGroupDatabase = ProgramGroupDatabase(this);
    programDatabase = ProgramDatabase(this);
    serverPublishDatabase = ServerPublishDatabase(this);
    cmdInfoDatabase = CmdInfoDatabase(this);
    operationRecordsDatabase = OperationRecordsDatabase(this);
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // 创建 资源类别 表
            await migrator.createTable(resourceType);
          }
          if (from < 3) {
            // 创建 资源 表
            await migrator.createTable(resource);
          }
          if (from < 4) {
            // 创建 终端组 表
            await migrator.createTable(terminalGroup);
          }
          if (from < 5) {
            // 创建 终端组 表
            await migrator.createTable(serverPublish);
          }

          if (from < 8) { // 新增：创建操作记录表
            await migrator.createTable(operationRecords);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await _getDatabaseFolder();
    print("dpFolder path:${dbFolder}");
    final file = File(p.join(dbFolder, 'app.db'));
    return NativeDatabase(file);
  });
}

Future<String> _getDatabaseFolder() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return (await getApplicationSupportDirectory()).path;
  }
  return (await getApplicationDocumentsDirectory()).path;
}
