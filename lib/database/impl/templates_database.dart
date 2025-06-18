import 'package:drift/drift.dart';
import 'package:snap_vison_client/util/TimeUtils.dart';
import '../database.dart'; // 引入主数据库类

part 'templates_database.g.dart';

@DriftAccessor(tables: [Templates,TemplateItems])
class TemplatesDatabase extends DatabaseAccessor<AppDatabase> with _$TemplatesDatabaseMixin {
  TemplatesDatabase(AppDatabase db) : super(db);

  // 初始化默认模板数据
  Future<void> initDefaultTemplate() async {
    final existingTemplates = await getAllTemplates();
    if (existingTemplates.isEmpty) {
      // 插入默认模板
      final templateId = await into(templates).insert(
        TemplatesCompanion.insert(
          body: Value(""),
          creator: "admin",
          desc: Value("默认系统模板"),
          groupId: 1,
          resolution: "1280*720",
          width: 1920,
          height: 1080,
          name: "系统模板01",
          preview: Value("data:image/png;base64,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"),
          terminalType: "安卓",
          type: "系统模板",
        ),
      );

      // 使用 batch 插入默认模板项
      await batch((batch) {
        batch.insertAll(templateItems, [
          TemplateItemsCompanion.insert(
            id: TimeUtils.getCurrentTimestamp().toString(),
            templateId: Value(templateId), // 关联到模板
            backGround: Value(""),
            height: 720,
            name: "image1",
            type: "image",
            width: 767.14,
            x: 0,
            y: 0,
            zIndex: 10,
          ),
          TemplateItemsCompanion.insert(
            id: TimeUtils.getCurrentTimestamp().toString(),
            templateId: Value(templateId), // 关联到模板
            backGround: Value(""),
            height: 202,
            name: "txt11",
            type: "txt",
            width: 421.43,
            x: 811,
            y: 251,
            zIndex: 11,
          ),
          TemplateItemsCompanion.insert(
            id: TimeUtils.getCurrentTimestamp().toString(),
            templateId: Value(templateId), // 关联到模板
            backGround: Value("http://192.168.116.190:3000/bg1.jpg"),
            height: 720,
            name: "BG",
            type: "BG",
            width: 1280,
            x: 0,
            y: 0,
            zIndex: 1,
          ),
        ]);
      });
    }
  }

  // 获取所有模板
  Future<List<Template>> getAllTemplates() {
    return select(templates).get();
  }

  // 根据 groupId 查询模板列表
  Future<List<Template>> getTemplatesByGroupId(int groupId) async{
    return (select(templates)..where((tbl) => tbl.groupId.equals(groupId))).get();
  }

  // 创建模板
  Future<int> createTemplate({
    required String body,
    required String creator,
    required List<TemplateItemsCompanion> temItems,
    required int groupId,
    required String name,
    required String type,
    required int width,
    required int height,
    required String preview,
    required String terminalType,
    required String desc,
  }) async {
    // 插入模板
    final templateId = await into(templates).insert(
      TemplatesCompanion.insert(
        body: Value(body),
        creator: creator,
        desc: Value(desc),
        groupId: groupId,
        resolution: "${width}*${height}",
        width: width,
        height: height,
        name: name,
        preview: Value(preview),
        terminalType: terminalType,
        type: type,
      ),
    );

    // 使用 batch 插入模板项
    await batch((batch) {
      for (var item in temItems) {
        batch.insert(templateItems, item.copyWith(templateId: Value(templateId))); // 关联到模板
      }
    });

    return templateId; // 返回新创建模板的 ID
  }


  // Update template
  Future<void> updateTemplate({
    required int templateId,
    required String body,
    required String creator,
    required List<TemplateItemsCompanion> temItems,
    required int groupId,
    required String name,
    required String type,
    required int width,
    required int height,
    required String preview,
    required String terminalType,
    required String desc,
  }) async {
    // Update template information
    await (update(templates)..where((tbl) => tbl.id.equals(templateId))).write(
      TemplatesCompanion(
        body: Value(body),
        creator: Value(creator),
        desc: Value(desc),
        groupId: Value(groupId),
        resolution: Value("${width}*${height}"),
        width: Value(width),
        height: Value(height),
        name: Value(name),
        preview: Value(preview),
        terminalType: Value(terminalType),
        type: Value(type),
      ),
    );

    // Delete existing template items
    await (delete(templateItems)..where((tbl) => tbl.templateId.equals(templateId))).go();

    // Insert new template items
    await batch((batch) {
      for (var item in temItems) {
        batch.insert(templateItems, item.copyWith(templateId: Value(templateId)));
      }
    });
  }

  //根据id获取模板
  Future<Template?> getTemplateById(int id) async {
    return (select(templates)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  //根据模板主id获取其下面的项目列表
  Future<List<TemplateItem>> getTemplateItemsByTemplateId(int templateId) async {
    return await (select(templateItems)..where((tbl) => tbl.templateId.equals(templateId))).get();
  }


  //根据模板id删除模板以及关联的item
  Future<void> deleteTemplateById(int templateId) async {
    await batch((batch) async {
      // 获取要删除的模板项数量
      final itemsToDelete = await (select(templateItems)
        ..where((tbl) => tbl.templateId.equals(templateId)))
          .get();
      print('即将删除模板 ID 为 $templateId 的 ${itemsToDelete.length} 个模板项');
      // 使用 deleteWhere 删除关联的模板项
      batch.deleteWhere(templateItems, (tbl) => tbl.templateId.equals(templateId));
      // 删除模板
      batch.deleteWhere(templates, (tbl) => tbl.id.equals(templateId));
    });
  }

  Future<void> deleteTemplatesByGroupId(int groupId) async {
    await batch((batch) async {
      // Get all templates in the group
      final templatesToDelete = await (select(templates)
        ..where((tbl) => tbl.groupId.equals(groupId)))
          .get();

      // Loop through each template and delete its associated items
      for (final template in templatesToDelete) {
        final templateId = template.id;
        final itemsToDelete = await (select(templateItems)
          ..where((tbl) => tbl.templateId.equals(templateId)))
            .get();
        print('About to delete ${itemsToDelete.length} template items for template ID $templateId');
        batch.deleteWhere(templateItems, (tbl) => tbl.templateId.equals(templateId));
      }

      // Delete all templates in the group
      batch.deleteWhere(templates, (tbl) => tbl.groupId.equals(groupId));
    });
  }


}