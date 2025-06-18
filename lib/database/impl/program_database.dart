import 'package:drift/drift.dart';
import 'package:snap_vison_client/util/TimeUtils.dart';
import '../database.dart'; // 引入主数据库类

part 'program_database.g.dart';

//节目
@DriftAccessor(tables: [Program,ProgramItems])
class ProgramDatabase extends DatabaseAccessor<AppDatabase> with _$ProgramDatabaseMixin {
  ProgramDatabase(AppDatabase db) : super(db);

  // 获取所有节目
  Future<List<ProgramData>> getAllProgram() {
    return select(program).get();
  }

  // 根据 groupId(节目组) 查询节目列表
  Future<List<ProgramData>> getProgramByGroupId(int groupId) async{
    return (select(program)..where((tbl) => tbl.groupId.equals(groupId))).get();
  }

  // 根据 groupId(节目组) 查询节目列表
  Future<List<ProgramData>> getProgramByName(String name) async{
    return (select(program)..where((tbl) => tbl.name.equals(name))).get();
  }

  // 根据节目ID查询节目（优化代码格式）
  Future<ProgramData?> getProgramById(int programId) async {
    return (select(program)
      ..where((tbl) => tbl.id.equals(programId)))
        .getSingleOrNull();
  }

  // 创建节目
  Future<int> createProgram({
    required int groupId,
    required int modelId,
    required String name,
    required String preview,
    required List<ProgramItemsCompanion> temItems,
  }) async {
    // 插入节目
    final programId = await into(program).insert(
      ProgramCompanion.insert(
        groupId: groupId,
        modelId: modelId,
        name: name,
        preview: Value(preview),
      ),
    );

    // 使用 batch 插入节目项
    await batch((batch) {
      for (var item in temItems) {
        batch.insert(programItems, item.copyWith(programId: Value(programId))); // 关联到模板
      }
    });

    return programId; // 返回新创建节目的 ID
  }

  //更新节目
  Future<void> updateProgram({
    required int programId,
    required int groupId,
    required int modelId,
    required String name,
    required String preview,
    required List<Map<String, dynamic>> temItems, // 每个 item 包含 itemsId 和 url
  }) async {
    // 1. 更新 program 表
    await (update(program)..where((tbl) => tbl.id.equals(programId))).write(
      ProgramCompanion(
        groupId: Value(groupId),
        modelId: Value(modelId),
        name: Value(name),
        preview: Value(preview),
      ),
    );

    // 2. 批量更新 programItems 表（根据 itemsId）
    await batch((batch) {
      for (final item in temItems) {
        final int itemsId =  int.tryParse(item['itemsId']) ?? 0;
        final String url = item['url'];

        batch.update(
          programItems,
          ProgramItemsCompanion(
            url: Value(url),
          ),
          where: (tbl) => tbl.itemsId.equals(item['itemsId']),
        );
      }
    });
  }


  // 根据programId查询与之绑定的programItems数据
  Future<List<ProgramItem>> getProgramItemsByProgramId(int programId) async {
    return (select(programItems)
      ..where((tbl) => tbl.programId.equals(programId)))
        .get();
  }

  // 根据programId和itemId查询对应的ProgramItems数据
  Future<ProgramItem?> getProgramItemByProgramIdAndItemId(int programId, String itemId) async {
    return (select(programItems)
      ..where((tbl) => tbl.programId.equals(programId) & tbl.itemsId.equals(itemId)))
        .getSingleOrNull();
  }

  // 删除节目及其关联的节目项
  Future<void> deleteProgram(int programId) async {
    await batch((batch) {
      // 删除关联的节目项
      batch.deleteWhere(programItems, (tbl) => tbl.programId.equals(programId));
      // 删除节目
      batch.deleteWhere(program, (tbl) => tbl.id.equals(programId));
    });
  }

}