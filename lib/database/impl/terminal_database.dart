import 'package:drift/drift.dart';
import 'package:snap_vison_client/util/TimeUtils.dart';
import '../../util/DeviceInfoUtil.dart';
import '../../util/SharedPreferencesUtils.dart';
import '../database.dart'; // 引入主数据库类

part 'terminal_database.g.dart';

@DriftAccessor(tables: [Terminal])
class TerminalDatabase extends DatabaseAccessor<AppDatabase> with _$TerminalDatabaseMixin {
  TerminalDatabase(AppDatabase db) : super(db);


  // 初始化设备
  Future<void> initDefaultTerminal() async {
    final existingTemplates = await getAllTerminal();
    if (existingTemplates.isEmpty) {
      // 获取设备信息
      String deviceId = DeviceInfo.getDeviceId();
      //这里存储ID
      SharedPreferencesUtils().setTerminalCode(deviceId);
      String osType = DeviceInfo.getOperatingSystem();
      String  screenResolution = DeviceInfo.getScreenResolution();
      String softwareVersion = await DeviceInfo.getCurrentSoftwareVersion();
      String systemVersion = DeviceInfo.getSystemVersion();
      String macAddress = await DeviceInfo.getMacAddress();
      print("获取设备信息\n osType:${osType}\n  deviceId:${deviceId}\n  screenResolution:${screenResolution}\n  softwareVersion:${softwareVersion}\n  systemVersion:${systemVersion}\n  macAddress:${macAddress}");
      await addTerminal(
          'DefaultDevice',
          deviceId,
          osType,
          "",
          screenResolution,
          softwareVersion,
          systemVersion,
          macAddress,
          "0",
          TimeUtils.getCurrentTimeString(),
          "none",
          1);
    }
  }

  // 添加设备
  Future<int> addTerminal(String name,String terminalCode,String type,String psw,String resolution,String sversion,String version,String mac,String status,String updateTime,String lastControlMsg,int groupId) async {
    return await into(terminal).insert(
      TerminalCompanion.insert(
        name:name,
        terminalCode: terminalCode,
        type: type,
        pasWord: psw,
        resolution: resolution,
        sversion: sversion,
        version: version,
        mac: mac,
        status: status,
        updateTime: updateTime,
        lastControlMsg: lastControlMsg,
        groupId: Value(groupId)
      ),
    );
  }

  //更新终端在线时间
  Future<int> updateTerminalTimeByTerminalCode(
      String terminalCode, {
        String? updateTime,
      }) async {
    final query = update(terminal)..where((t) => t.terminalCode.equals(terminalCode));
    return query.write(TerminalCompanion(
      updateTime: updateTime != null ? Value(updateTime) : const Value.absent(),
      status: Value("1"),
    ));
  }


  //设置(更新)终端参数
  Future<int> modifyTerminalParams(
      String terminalCode, {
        String? name,
        String? psw,
      }) async {
    final query = update(terminal)..where((t) => t.terminalCode.equals(terminalCode));
    return query.write(TerminalCompanion(
      name: name!= null? Value(name) : const Value.absent(),
      pasWord: psw!= null? Value(psw) : const Value.absent(),
    ));
  }

  // 获取所有设备列表
  Future<List<TerminalData>> getAllTerminal() async {
    return await select(terminal).get();
  }

  // 根据 groupId 查询终端
  Future<List<TerminalData>> getTerminalsByGroupId(int groupId) async {
    return await(select(terminal)..where((tbl) => tbl.groupId.equals(groupId))).get();
  }

  // 根据 terminalCode 查询终端实体类
  Future<TerminalData?> getTerminalByTerminalCode(String terminalCode) async {
    // 构建查询条件，筛选出 terminalCode 匹配的记录
    final query = select(terminal)
      ..where((t) => t.terminalCode.equals(terminalCode));
    // 执行查询并获取单条记录，若不存在则返回 null
    return await query.getSingleOrNull();
  }

  // 根据 terminalCode 查询终端密码
  Future<String> getTerminalPswByTerminalCode(String terminalCode) async {
    // 构建查询条件，筛选出 terminalCode 匹配的记录
    final query = select(terminal)
      ..where((t) => t.terminalCode.equals(terminalCode));
    // 执行查询并获取单条记录，若不存在则返回 null
    TerminalData? terminalData = await query.getSingleOrNull();
    if(terminalData != null){
      return terminalData.pasWord;
    } else {
      return "";
    }
  }
}