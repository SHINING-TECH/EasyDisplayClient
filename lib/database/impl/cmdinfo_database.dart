import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'cmdinfo_database.g.dart';

@DriftAccessor(tables: [CmdInfo])
class CmdInfoDatabase extends DatabaseAccessor<AppDatabase> with _$CmdInfoDatabaseMixin {
  CmdInfoDatabase(AppDatabase db) : super(db);

  // 添加推送指令
  Future<int> addCmdInfo(String type) async {
    return await into(cmdInfo).insert(
      CmdInfoCompanion.insert(
        pushType:type,
      ),
    );
  }

  // 查询所有 CmdInfo 记录
  Future<List<CmdInfoData>> getAllCmdInfo() {
    return select(cmdInfo).get();
  }

  // 根据 ID 查询 CmdInfo 记录
  Future<CmdInfoData?> getCmdInfoById(int id) {
    return (select(cmdInfo)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // 删除 CmdInfo 记录
  Future<int> deleteCmdInfo(int id) {
    return (delete(cmdInfo)..where((tbl) => tbl.id.equals(id))).go();
  }


  // 新增查询最新记录方法
  Future<CmdInfoData?> getLatestCmdInfo() {
    return (select(cmdInfo)
      ..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
      ..limit(1))
        .getSingleOrNull();
  }

  // 组合操作：查询并更新flag（原子操作）
  Future<bool> updateCmdFlagById(int id) async {
    final affectedRows = await updateCmdFlag(id);
    return affectedRows > 0;
  }

  // 根据ID更新flag状态
  Future<int> updateCmdFlag(int id) async {
    return (update(cmdInfo)..where((tbl) => tbl.id.equals(id)))
        .write(CmdInfoCompanion(
        flag: const Value(1)
    ));
  }
}