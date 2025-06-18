import 'package:drift/drift.dart';
import '../database.dart'; // 引入主数据库类

part 'operationrecords_database.g.dart';

@DriftAccessor(tables: [OperationRecords])
class OperationRecordsDatabase extends DatabaseAccessor<AppDatabase> with _$OperationRecordsDatabaseMixin {
  OperationRecordsDatabase(AppDatabase db) : super(db);

  /// 新增操作记录
  /// [userName] 用户名
  /// [userId] 用户 ID
  /// [operationDetail] 操作详情
  Future<int> insertRecord(String userName, int userId, String operationDetail) {
    print("insertRecord userName:$userName userId:$userId operationDetail:$operationDetail");
    // 创建 OperationRecordsCompanion 实例，传入必要参数
    final record = OperationRecordsCompanion(
      userName: Value(userName),
      userId: Value(userId),
      operationDetail: Value(operationDetail),
      // 假设 operationTime 是必须字段，设置当前时间
      operationTime: Value(DateTime.now()),
    );
    return into(operationRecords).insert(record);
  }

  /// 删除操作记录
  /// [id] 记录的主键 ID
  Future<int> deleteRecord(int id) {
    return (delete(operationRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 查询所有操作记录
  Future<List<OperationRecord>> getAllRecords() {
    // 修正链式调用格式，确保 get() 方法正确调用
    return (select(operationRecords)
      ..orderBy([(t) => OrderingTerm(expression: t.operationTime, mode: OrderingMode.desc)]))
        .get();
  }

  /// 根据人员 ID 查询操作记录，创建时间越近的在列表前面
  /// [userId] 用户 ID
  Future<List<OperationRecord>> getRecordsByUserId(int userId) {
    return (select(operationRecords)
      ..where((tbl) => tbl.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.operationTime, mode: OrderingMode.desc)]))
        .get();
  }
}