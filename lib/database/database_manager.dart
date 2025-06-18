import 'dart:ffi';

import '../util/TimeUtils.dart';
import 'database.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  late final AppDatabase database;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal() {
    database = AppDatabase();
    _init();
  }

  Future<void> _init() async {
    await database.userDatabase.initDefaultUser();
    await database.resourceTypeDatabase.initDefaultResourceType();
    //await database.resourceDatabase.initDefaultResource();
    await database.tempGroupDatabase.initDefaultTemplates();
    await database.terminalGroupDatabase.initDefaultTerminalGroup();
    await database.templatesDatabase.initDefaultTemplate();
    await database.terminalDatabase.initDefaultTerminal();
    await database.programGroupDatabase.initDefaultProgramGroup();
  }

  // 用户登录
  Future<bool> login(String username, String password) async {
    return await database.userDatabase.validateUser(username, password);
  }

  // 查询用户信息
  Future<User?> queryUserInfo(String username) async {
    return await database.userDatabase.getUserInfo(username);
  }

  // 修改密码
  Future<String> changePassword(String username, String oldPassword, String newPassword, String secQues, String secAnswer) async {
     // 调用数据库方法修改密码
     final result = await database.userDatabase.changePassword(username, oldPassword, newPassword, secQues, secAnswer);
     // 判断返回结果是否为成功信息
     return result;
  }

  // 重置密码
  Future<String> resetPsw(String username,String securityAnswer) async {
    return await database.userDatabase.resetPsw(username,securityAnswer);
  }

  // 获取所有资源类型
  Future<List<ResourceTypeData>> getAllResourceType() async {
    return await database.resourceTypeDatabase.getAllResourcesType();
  }

  //传入资源类型，获取下面分组数据
  Future<List<ResourceGroupData>> getResourceGroupsByType(String type) async {
    return await database.resourceTypeDatabase.getResourceGroupsByType(type);
  }

  //创建资源组
  Future<int> addResourceGroup(String type,String groupName) async {
    return await database.resourceTypeDatabase.addResourceGroup(type,groupName);
  }

  //查询资源组名称
  Future<String> getResourceGroupNameById(int groupId) async {
    return await database.resourceTypeDatabase.getResourceGroupNameById(groupId);
  }

  //删除资源组
  Future<int> deleteResourceGroup(int groupId) async {
    return await database.resourceTypeDatabase.deleteResourceGroup(groupId);
  }

  // 获取所有资源
  Future<List<ResourceData>> getAllResources() async {
    return await database.resourceDatabase.getAllResources();
  }

  // 获取所有资源
  Future<List<ResourceData>> getResourcesByGroupId(int groupId) async {
    return await database.resourceDatabase.getResourcesByGroupId(groupId);
  }

  // 获取所有指定资源组下面的所有资源id列表
  Future<List<int>> getResourceIdsByGroupId(int groupId) async {
    return await database.resourceDatabase.getResourceIdsByGroupId(groupId);
  }

  //根据资源Id获取资源实体类
  Future<ResourceData?> getResourceById(int id) async {
    return await database.resourceDatabase.getResourceById(id);
  }


  //插入资源数据
  Future<int> addResources(String type,int groupId,String name,String url,String thumbnail,String localFilePath,int size,String showFileSize) async {
    return await database.resourceDatabase.addResource(type,groupId, name, url, thumbnail,localFilePath,size,showFileSize);
  }
  
  // 删除资源数据
  Future<ResourceData?> deleteResource(int id) async {
    return await database.resourceDatabase.deleteResourceById(id);
  }

  // 获取所有模板种类(默认:系统模板，用户模板)
  Future<List<TemplatesGroupData>> getAllTemplatesGroup() async {
    return await database.tempGroupDatabase.getAllTemplateGroups();
  }

  //添加子模板组
  Future<int> addChildTemplateGroup(String label,int fatherId) async {
    return await database.tempGroupDatabase.addChildTemplateGroup(label,fatherId);
  }

  //根据groupId获取模板组实体类
  Future<TemplatesGroupData?> getTemplateGroupById(int groupId) async {
    return await database.tempGroupDatabase.getTemplateGroupById(groupId);
  }

  // 获取所有模板种类(默认:系统模板，用户模板)
  Future<List<TemplatesGroupData>> getAllParentTemplateGroups() async {
    return await database.tempGroupDatabase.getAllParentTemplateGroups();
  }

  // 获取所有模板种类(默认:系统模板，用户模板)
  Future<List<TemplatesGroupData>> getTemplateGroupsByFatherId(int fatherId) async {
    return await database.tempGroupDatabase.getTemplateGroupsByFatherId(fatherId);
  }

  //删除模板组
  Future<int> deleteTemplateGroup(int groupId) async {
    return await database.tempGroupDatabase.deleteTemplateGroup(groupId);
  }

  // 获取所有模板
  Future<List<Template>> getAllTemplates() async{
    return await database.templatesDatabase.getAllTemplates();
  }
  // 根据 groupId 获取模板列表
  Future<List<Template>> getTemplatesByGroupId(int groupId) async{
    return await database.templatesDatabase.getTemplatesByGroupId(groupId);
  }

  //根据id获取模板
  Future<Template?> getTemplateById(int id) async {
    return await database.templatesDatabase.getTemplateById(id);
  }

  //根据模板主id获取其下面的项目列表
  Future<List<TemplateItem>> getTemplateItemsByTemplateId(int templateId) async {
    return await database.templatesDatabase.getTemplateItemsByTemplateId(templateId);
  }

  //根据模板组id批量删除模板
  Future<void> deleteTemplatesByGroupId(int groupId) async {
    await database.templatesDatabase.deleteTemplatesByGroupId(groupId);
  }

  //根据模板主id删除模板
  Future<void> deleteTemplateById(int templateId) async {
     await database.templatesDatabase.deleteTemplateById(templateId);
  }

  // 创建模板
  Future<int> createTemplate(
      String body,
      String creator,
      List<TemplateItemsCompanion> temItems,
      int groupId,
      String name,
      String type,
      int width,
      int height,
      String preview,
      String terminalType,
      String desc) async {
    return await database.templatesDatabase.createTemplate(
      body: body,
      creator: creator,
      temItems: temItems,
      groupId: groupId,
      name: name,
      type: type,
      width: width,
      height: height,
      preview: preview,
      terminalType: terminalType,
      desc: desc,
    );
  }

  // 更新模板 - 中间调用函数
  Future<void> updateTemplate(
      int templateId,
      String body,
      String creator,
      List<TemplateItemsCompanion> temItems,
      int groupId,
      String name,
      String type,
      int width,
      int height,
      String preview,
      String terminalType,
      String desc) async {
    return await database.templatesDatabase.updateTemplate(
      templateId: templateId,
      body: body,
      creator: creator,
      temItems: temItems,
      groupId: groupId,
      name: name,
      type: type,
      width: width,
      height: height,
      preview: preview,
      terminalType: terminalType,
      desc: desc,
    );
  }

  // 获取所有终端组
  Future<List<TerminalGroupData>> getAllTerminalGroups() async {
    return await database.terminalGroupDatabase.getAllTerminalGroups();
  }

  //新建终端
  Future<int> addTerminals() async{
    return await database.terminalDatabase.addTerminal("", "", "","", "", "", "", "", "", "", "", 1);
  }

  //更新终端在线时间
  Future<int> updateTerminalTimeByTerminalCode(String terminalCode) async{
    return await database.terminalDatabase.updateTerminalTimeByTerminalCode(
        terminalCode,
        updateTime:TimeUtils.getCurrentTimeString(),
    );
  }

  //更新终端参数
  Future<int> modifyTerminalParams(String terminalCode,String name,String psw) async{
    return await database.terminalDatabase.modifyTerminalParams(
        terminalCode,
        name: name,
        psw: psw,
    );
  }

  // 根据 groupId 获取终端
  Future<List<TerminalData>> getAllTerminals() async{
    return await database.terminalDatabase.getAllTerminal();
  }

  // 根据 groupId 获取终端
  Future<List<TerminalData>> getTerminalsByGroupId(int groupId) async{
    return await database.terminalDatabase.getTerminalsByGroupId(groupId);
  }

  // 根据 terminalCode 获取终端密码
  Future<String> getTerminalsPsw(String terminalCode) async{
    return await database.terminalDatabase.getTerminalPswByTerminalCode(terminalCode);
  }

  // 获取所有父节目组
  Future<List<ProgramGroupData>> getAllParentProgramGroups() async {
    return await database.programGroupDatabase.getAllParentProgramGroups();
  }


  // 获取所有子节目组
  Future<List<ProgramGroupData>> getProgramGroupsByFatherId(int fatherId) async {
    return await database.programGroupDatabase.getProgramGroupsByFatherId(fatherId);
  }

  //创建节目组或子节目组
  Future<int> addProgramGroupWithFatherId(String label, int? fatherId) async {
    return await database.programGroupDatabase.addProgramGroupWithFatherId(label, fatherId);
  }

  //根据id获取节目组
  Future<ProgramGroupData?> getProgramGroupById(int groupId) async {
    return await database.programGroupDatabase.getProgramGroupById(groupId);
  }

  //删除节目组以及子组
  Future<void> deleteProgramGroupAndChildren(int groupId) async{
    return await database.programGroupDatabase.deleteProgramGroupAndChildren(groupId);
  }

  // 获取所有节目列表
  Future<List<ProgramData>> getAllPrograms() async{
    return await database.programDatabase.getAllProgram();
  }

  // 根据 groupId(节目组ID) 获取节目列表
  Future<List<ProgramData>> getProgramsByGroupId(int groupId) async{
    return await database.programDatabase.getProgramByGroupId(groupId);
  }

  // 根据 name 获取节目列表
  Future<List<ProgramData>> getProgramByName(String name) async{
    return await database.programDatabase.getProgramByName(name);
  }

  // 根据 programId(节目ID) 获取节目数据
  Future<ProgramData?> getProgramByProgramId(int programId) async{
    return await database.programDatabase.getProgramById(programId);
  }

  // 创建节目
  Future<int> createProgram(
       int groupId,
       int modelId,
       String name,
       String preview,
       List<ProgramItemsCompanion> temItems) async {
    return await database.programDatabase.createProgram(
      groupId: groupId,
      modelId: modelId,
      name: name,
      preview: preview,
      temItems: temItems
    );
  }

  // 创建节目
  Future<void> updateProgram(
      int programId,
      int groupId,
      int modelId,
      String name,
      String preview,
      List<Map<String, dynamic>> temItems) async {
     await database.programDatabase.updateProgram(
        programId: programId,
        groupId: groupId,
        modelId: modelId,
        name: name,
        preview: preview,
        temItems: temItems
    );
  }

  //根据节目ID查询出节目下的item定义数据
  Future<List<ProgramItem>> getProgramItemsByProgramId(int programId) async {
    return await database.programDatabase.getProgramItemsByProgramId(programId);
  }

  //根据节目ID查询出节目下的item定义数据
  Future<ProgramItem?> getProgramItemByProgramIdAndItemId(int programId,String itemID) async {
    return await database.programDatabase.getProgramItemByProgramIdAndItemId(programId,itemID);
  }

  //删除节目
  Future<void> deleteProgram(int programId) async {
     await database.programDatabase.deleteProgram(programId);
  }


  // 创建节目发布数据
  Future<int> createServerPublish(
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
      String? type) async {
    return await database.serverPublishDatabase.createServerPublish(
      programName: programName,
      date: date,
      disStrategy: disStrategy,
      disType: disType,
      invalidTime: invalidTime,
      makeTime: makeTime,
      playMode: playMode,
      proId: proId,
      proType: proType,
      publisher: publisher,
      terminalId: terminalId,
      time: time,
      type: type,
    );
  }

  // 获取所有发布的节目列表
  Future<List<ServerPublishData>> getAllServerPublishes() async{
    return await database.serverPublishDatabase.getAllServerPublishes();
  }

  //根据ID删除发布数据
  //插入一条指令
  Future<int> deleteServerPublishById(int publishId) async {
    return await database.serverPublishDatabase.deleteServerPublishById(publishId);
  }

  //根据设备ID获取最新发布的节目
  Future<ServerPublishData?> getServerPublishById(int publishId) async{
    return await database.serverPublishDatabase.getServerPublishById(publishId);
  }

  //根据设备ID获取最新发布的节目
  Future<ServerPublishData?> getLatestServerPublishByTerminalId(String terminalId) async{
    return await database.serverPublishDatabase.getLatestServerPublishByTerminalId(terminalId);
  }

  //插入一条指令
  Future<int> addCmdInfo(String pushType) async {
    return await database.cmdInfoDatabase.addCmdInfo(pushType);
  }

  //获取最近一次插入的数据
  Future<CmdInfoData?> getLatestCmdInfo() async {
    return await database.cmdInfoDatabase.getLatestCmdInfo();
  }

  //将cmd flag变为1
  Future<bool> updateCmdFlagById(int id) async {
    return await database.cmdInfoDatabase.updateCmdFlagById(id);
  }

  //插入操作记录
  Future<int> insertRecord(String userName, String operationDetail) async {
    // 调用 queryUserInfo 方法获取用户信息
    final user = await queryUserInfo(userName);
    if (user != null) {
      // 若用户存在，使用获取到的用户 ID 插入操作记录
      return await database.operationRecordsDatabase.insertRecord(userName, user.id, operationDetail);
    }
    // 若用户不存在，返回 -1 表示插入失败
    return -1;
  }

  //查询所有操作记录
  Future<List<OperationRecord>> getAllRecords() async {
    return await database.operationRecordsDatabase.getAllRecords();
  }

  //根据人员 ID 查询操作记录，创建时间越近的在列表前面
  Future<List<OperationRecord>> getRecordsByUserId(int userId) async {
    if (userId == -1) {
      return await database.operationRecordsDatabase.getAllRecords();
    }
    return await database.operationRecordsDatabase.getRecordsByUserId(userId);
  }

} 