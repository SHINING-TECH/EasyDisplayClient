import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'serverpublish_database.g.dart';

//服务端发布数据库
@DriftAccessor(tables: [ServerPublish])
class ServerPublishDatabase extends DatabaseAccessor<AppDatabase> with _$ServerPublishDatabaseMixin {
  ServerPublishDatabase(AppDatabase db) : super(db);

  // 添加 ServerPublish 记录
  Future<int> createServerPublish({
    String? programName,
    String? date,
    String? disStrategy,
    String? disType,
    String? invalidTime,
    String? makeTime,
    String? playMode,
    String? proId,
    int? proType,
    String? publisher,
    String? terminalId,
    String? time,
    String? type,
  }) async {
    return await into(serverPublish).insert(
      ServerPublishCompanion.insert(
        programName: programName != null ? Value(programName) : const Value('None'),
        date: date != null ? Value(date) : Value.absent(),
        disStrategy: disStrategy != null ? Value(disStrategy) : const Value('null'),
        disType: disType != null ? Value(disType) : const Value('null'),
        invalidTime: invalidTime != null ? Value(invalidTime) : Value.absent(),
        makeTime: makeTime != null ? Value(makeTime) : Value.absent(),
        playMode: playMode != null ? Value(playMode) : const Value('loop'),
        proId: proId != null ? Value(proId) : const Value("0"),
        proType: proType != null ? Value(proType) : const Value(1),
        publisher: publisher != null ? Value(publisher) : const Value('admin'),
        terminalId: terminalId != null ? Value(terminalId) : const Value("0"),
        time: time != null ? Value(time) : Value.absent(),
        type: type != null ? Value(type) : const Value('date'),
      ),
    );
  }

  /// 查询所有服务端发布记录
  Future<List<ServerPublishData>> getAllServerPublishes() {
    return (select(db.serverPublish)
      ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)
      ]))
        .get();
  }

  /// 根据 ID 查询服务端发布记录
  /// [id] 要查询的服务端发布记录的 ID
  Future<ServerPublishData?> getServerPublishById(int id) {
    return (select(db.serverPublish)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// 更新服务端发布记录
  /// [serverPublish] 要更新的服务端发布记录
  Future<int> updateServerPublish(ServerPublishData serverPublish) {
    return (update(db.serverPublish)..where((tbl) => tbl.id.equals(serverPublish.id))).write(serverPublish);
  }

  /// 根据 ID 删除服务端发布记录
  /// [id] 要删除的服务端发布记录的 ID
  Future<int> deleteServerPublishById(int id) {
    return (delete(db.serverPublish)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 根据设备 ID 查询最近时间的 ServerPublish 数据
  /// [terminalId] 要查询的设备 ID
  /// 返回最近时间的 ServerPublish 数据，如果没有则返回 null
  Future<ServerPublishData?> getLatestServerPublishByTerminalId(String terminalId) {
    return (select(db.serverPublish)
      ..where((tbl) => tbl.terminalId.equals(terminalId))
      ..orderBy([
            (tbl) => OrderingTerm(
            expression: tbl.updatedAt,
            mode: OrderingMode.desc)
      ])
      ..limit(1))
        .getSingleOrNull();
  }

}