import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'programgroup_database.g.dart'; // 生成的文件

@DriftAccessor(tables: [ProgramGroup])
class ProgramGroupDatabase extends DatabaseAccessor<AppDatabase>
    with _$ProgramGroupDatabaseMixin {
  ProgramGroupDatabase(AppDatabase db) : super(db);

  // 初始化默认节目组
  Future<void> initDefaultProgramGroup() async {
    final existingTerminalGroups = await getAllProgramGroup();
    if (existingTerminalGroups.isEmpty) {
      await addProgramGroupWithFatherId('Default Program Group', null);
    }
  }


  // 根据 label 和 fatherId 添加子节目组
  Future<int> addProgramGroupWithFatherId(String label, int? fatherId) async {
    if (fatherId == null) {
      return await into(programGroup).insert(
        ProgramGroupCompanion.insert(
          label: label,
        ),
      );
    }
    return await into(programGroup).insert(
      ProgramGroupCompanion.insert(
        label: label,
        fatherId: Value(fatherId),
      ),
    );
  }

  // 获取所有节目组
  Future<List<ProgramGroupData>> getAllProgramGroup() async {
    return await select(programGroup).get();
  }

  // 获取所有父模板组（fatherId 为空）
  Future<List<ProgramGroupData>> getAllParentProgramGroups() async {
    return await (select(programGroup)..where((t) => t.fatherId.isNull())).get();
  }

  // 根据 ID 查询模板组数据
  Future<ProgramGroupData?> getProgramGroupById(int id) async {
    return await (select(programGroup)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 根据父 ID 查询模板组数据
  Future<List<ProgramGroupData>> getProgramGroupsByFatherId(int fatherId) async {
    return await (select(programGroup)..where((t) => t.fatherId.equals(fatherId))).get();
  }

  // 递归删除组及其所有子组
  Future<void> deleteProgramGroupAndChildren(int groupId) async {
    // 先删除所有子组
    final childGroups = await getProgramGroupsByFatherId(groupId);
    for (final childGroup in childGroups) {
      await deleteProgramGroupAndChildren(childGroup.id);
    }
    // 最后删除当前组
    await _deleteProgramGroup(groupId);
  }

  // 删除单个组的私有方法
  Future<void> _deleteProgramGroup(int groupId) async {
    await (delete(programGroup)..where((tbl) => tbl.id.equals(groupId))).go();
  }

}
