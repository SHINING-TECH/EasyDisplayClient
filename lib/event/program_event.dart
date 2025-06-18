//发布节目event
class ProgramIdEvent {
  // 定义事件类型 publish 发布计划  delete 删除计划
  final String type;
  final int publishId;

  ProgramIdEvent(this.type,this.publishId);
}