import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'resourcetype_database.g.dart';

@DriftAccessor(tables: [ResourceType,ResourceGroup])
class ResourceTypeDatabase extends DatabaseAccessor<AppDatabase> with _$ResourceTypeDatabaseMixin {
  ResourceTypeDatabase(AppDatabase db) : super(db);


  // 初始化默认模资源类型
  Future<void> initDefaultResourceType() async {
    final existingTemplates = await getAllResourcesType();
    if (existingTemplates.isEmpty) {
      await addResourcesType('image', 'Image');
      await addResourceGroup('image', 'Default Group');
      await addResourcesType('video', 'Video');
      await addResourceGroup('video', 'Default Group');
      await addResourcesType('audio', 'Audio');
      await addResourceGroup('audio', 'Default Group');
    }
  }

  // 添加资源类型
  Future<int> addResourcesType(String type,String label) async {
    return await into(resourceType).insert(
      ResourceTypeCompanion.insert(
        type:type,
        label: label,
      ),
    );
  }

  Future<int> addResourceGroup(String type, String groupName) async {
    return await into(resourceGroup).insert(
      ResourceGroupCompanion.insert(
        type: type,
        groupName: groupName,
      ),
    );
  }

  // 获取所有资源类型
  Future<List<ResourceTypeData>> getAllResourcesType() async {
    return await select(resourceType).get();
  }

  // 根据类型获取资源分组数据
  Future<List<ResourceGroupData>> getResourceGroupsByType(String type) async {
    return await (select(resourceGroup)..where((t) => t.type.equals(type))).get();
  }

  // 根据资源组id获取资源组名称
  Future<String> getResourceGroupNameById(int groupId) async {
    //查询出groupId对应实体类
    final group = await (select(resourceGroup)..where((t) => t.id.equals(groupId))).getSingleOrNull();
    if (group != null) {
      return group.groupName;
    }else{
      return "";
    }
  }

  // 删除资源组
  Future<int> deleteResourceGroup(int groupId) async {
    return await (delete(resourceGroup)..where((t) => t.id.equals(groupId))).go();
  }
}