import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'tempgroup_database.g.dart'; // 生成的文件

@DriftAccessor(tables: [TemplatesGroup])
class TempGroupDatabase extends DatabaseAccessor<AppDatabase> with _$TempGroupDatabaseMixin {
  TempGroupDatabase(AppDatabase db) : super(db);


  // 初始化默认模板组
  Future<void> initDefaultTemplates() async {
    final existingTemplates = await getAllTemplateGroups();
    if (existingTemplates.isEmpty) {
      await addTemplate('System Templates');
      await addTemplate('User Templates');
    }
  }

  // 添加模板组
  Future<int> addTemplate(String label) async {
    return await into(templatesGroup).insert(
      TemplatesGroupCompanion.insert(
        label: label,
      ),
    );
  }

  // 添加子模板组
  Future<int> addChildTemplateGroup(String label,int fatheId) async {
    return await into(templatesGroup).insert(
      TemplatesGroupCompanion.insert(
        label: label,
        fatherId: Value(fatheId),
      ),
    );
  }

  // 获取所有模板组
  Future<List<TemplatesGroupData>> getAllTemplateGroups() async {
    return await select(templatesGroup).get();
  }

  // 获取所有父模板组（fatherId 为空）
  Future<List<TemplatesGroupData>> getAllParentTemplateGroups() async {
    return await (select(templatesGroup)..where((t) => t.fatherId.isNull())).get();
  }

  // 根据父 ID 查询模板组数据
  Future<List<TemplatesGroupData>> getTemplateGroupsByFatherId(int fatherId) async {
    return await (select(templatesGroup)..where((t) => t.fatherId.equals(fatherId))).get();
  }

  // 根据 ID 查询模板组
  Future<TemplatesGroupData?> getTemplateGroupById(int id) async {
    return await (select(templatesGroup)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 更新模板组
  Future<bool> updateTemplate(int id, String newLabel) async {
    final template = await (select(templatesGroup)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (template != null) {
      await (update(templatesGroup)..where((t) => t.id.equals(id))).write(
        TemplatesGroupCompanion(
          label: Value(newLabel),
        ),
      );
      return true;
    }
    return false;
  }

  // 删除模板组
  Future<int> deleteTemplateGroup(int id) async {
    return await (delete(templatesGroup)..where((t) => t.id.equals(id))).go();
  }
}