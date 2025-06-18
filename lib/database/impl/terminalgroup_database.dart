import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'terminalgroup_database.g.dart'; // 生成的文件

@DriftAccessor(tables: [TerminalGroup])
class TerminalGroupDatabase extends DatabaseAccessor<AppDatabase> with _$TerminalGroupDatabaseMixin {
  TerminalGroupDatabase(AppDatabase db) : super(db);


  // 初始化默认模板组
  Future<void> initDefaultTerminalGroup() async {
    final existingTerminalGroups = await getAllTerminalGroups();
    if (existingTerminalGroups.isEmpty) {
      await addTerminalGroup('默认终端组');
    }
  }

  // 添加模板
  Future<int> addTerminalGroup(String label) async {
    return await into(terminalGroup).insert(
      TerminalGroupCompanion.insert(
        label: label,
      ),
    );
  }

  // 获取所有模板
  Future<List<TerminalGroupData>> getAllTerminalGroups() async {
    return await select(terminalGroup).get();
  }
}