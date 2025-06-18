import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:snap_vison_client/config/app_config.dart';
import 'package:snap_vison_client/util/DeviceInfoUtil.dart';
import '../manager/file_path_manager.dart';
import 'api/ApiCmd.dart';
import 'api/ApiOperationRecord.dart';
import 'api/ApiProgram.dart';
import 'api/ApiProgramGroup.dart';
import 'api/ApiPublish.dart';
import 'api/ApiResource.dart';
import 'api/ApiResourceType.dart';
import 'api/ApiTemplate.dart';
import 'api/ApiTerminal.dart';
import 'api/ApiTerminalGroup.dart';
import 'api/ApiUser.dart';
import 'api/Login.dart';
import 'api/ApiTemplateGroup.dart';

class ServerManage {
  //登录相关
  final apiLogIn = Login();
  //用户相关
  final apiUser = ApiUser();
  //模板组
  final apiGetTemplatesGroups = ApiTemplateGroup();
  //模板
  final apiTemplate = ApiTemplate();
  //资源类型相关接口
  final apiApiResourceType = ApiResourceType();
  //资源相关接口 - 增删改查，上传
  final apiApiResource = ApiResource();
  //终端组
  final apiTerminalGroup = ApiTerminalGroup();
  //终端
  final apiTerminal = ApiTerminal();
  //节目组
  final apiProgramGroup = ApiProgramGroup();
  //节目
  final apiProgram = ApiProgram();
  //发布
  final apiPublish = ApiPublish();
  //推送操作消息
  final apiCmd = ApiCmd();
  //用户操作记录
  final apiUserRecord = ApiOperationRecord();
  /**
   * 启动web服务
   */

  String _defaultDoc = 'index.html';

  Handler get handler {
    final router = Router();

    // 添加 CORS 处理
    router.options('/<path|.*>', (Request request) {
      return Response.ok('OK', headers: {
        'Access-Control-Allow-Origin': 'http://localhost:8666',
        'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      });
    });

    // Handlers can be added with `router.<verb>('<route>', handler)`, the
    // '<route>' may embed URL-parameters, and these may be taken as parameters
    // by the handler (but either all URL parameters or no URL parameters, must
    // be taken parameters by the handler).
    router.get('/say-hi/<name>', (Request request, String name) {
      return Response.ok('hi $name');
    });

    // Embedded URL parameters may also be associated with a regular-expression
    // that the pattern must match.
    router.get('/user/<userId|[0-9]+>', (Request request, String userId) {
      return Response.ok('User has the user-number: $userId');
    });

    // Handlers can be asynchronous (returning `FutureOr` is also allowed).
    router.get('/wave', (Request request) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return Response.ok('_o/');
    });

    /**
     *  登录请求,对应前端请求url为 http://localhost:8080/login
     */
    router.post('/login', apiLogIn.login);
    /*************************************用户*****************************************************/
    //修改密码
    router.post('/setPsw', apiUser.setPsw);

    //获取用户信息
    router.post('/getUserInfo', apiUser.getUserInfo);

    //重置密码
    router.post('/resetPassword', apiUser.resetPassword);


    /*************************************资源*****************************************************/
    /**
     *  获取所有资源类型数据,对应前端请求url为 http://localhost:8080/getAllResourceType
     */
    router.get('/getAllResourceType', apiApiResourceType.getAllResourceTypes);

    /**
     *  创建资源组,对应前端请求url为 http://localhost:8080/createResourceGroup
     */
    router.post('/createResourceGroup', apiApiResourceType.createResourceGroup);

    /**
     * 删除资源组-目前删除资源组，资源组内的资源文件一并删除掉
     */
    router.post('/deleteResourceGroup', apiApiResourceType.deleteResourceGroup);

    /**
     *  查询资源数据,对应前端请求url为 http://localhost:8080/queryResource
     */
    router.get('/queryResource', apiApiResource.getResource);
    /**
     * 上传资源文件
     */
    router.post('/upload', apiApiResource.upLoadResourceFile);
    /**
     * 删除资源文件
     */
    router.delete('/delete', apiApiResource.deleteResource);
    /*************************************模板*****************************************************/
    /**
     *  获取所有模板组数据,对应前端请求url为 http://localhost:8080/getAllTemplateGroups
     */
    router.get('/getAllTemplateGroups', apiGetTemplatesGroups.getAllTemplateGroups);
    /**
     *  创建模板组,对应前端请求url为 http://localhost:8080/createTemplateGroup
     */
    router.post('/createTemplateGroup', apiGetTemplatesGroups.createTemplateGroup);

    /**
     *  删除模板组,对应前端请求url为 http://localhost:8080/deleteTemplateGroup
     */
    router.post('/deleteTemplateGroup', apiGetTemplatesGroups.deleteTemplateGroup);

    /**
     *  获取所有模板,对应前端请求url为 http://localhost:8080/getTemplates
     */
    router.get('/getTemplates', apiTemplate.getTemplates);
    /**
     *  新建模板,对应前端请求url为 http://localhost:8080/newTemplate
     */
    router.post('/newTemplate', apiTemplate.newTemplate);

    /**
     *  更新模板,对应前端请求url为 http://localhost:8080/updateTemplate
     */
    router.post('/updateTemplate', apiTemplate.updateTemplate);

    /**
     *  删除模板,对应前端请求url为 http://localhost:8080/newTemplate
     */
    router.delete('/deleteTemplate', apiTemplate.deleteTemplate);
    /**
     *  根据模板ID获取模板,对应前端请求url为 http://localhost:8080/newTemplate
     */
    router.get('/getTemplateById', apiTemplate.getTemplateById);
    /*************************************终端*****************************************************/
    /**
     *  获取所有终端组数据,对应前端请求url为 http://localhost:8080/getAllTerminalGroups
     */
    router.get('/getAllTerminalGroups', apiTerminalGroup.getAllTerminalGroups);

    /**
     *  获取所有终端组数据,对应前端请求url为 http://localhost:8080/queryTerminal
     */
    router.get('/queryTerminal', apiTerminal.getTerminals);

    /**
     *  修改终端参数（名称，密码）,对应前端请求url为 http://localhost:8080/modifyTerminalParams
     */
    router.post('/modifyTerminalParams', apiTerminal.modifyTerminalParams);

    /*************************************节目组*****************************************************/

    /**
     *  查询节目组,对应前端请求url为 http://localhost:8080/getAllProgramGroups
     */
    router.get('/getAllProgramGroups', apiProgramGroup.getAllProgramGroups);

    /**
     *  创建节目组,对应前端请求url为 http://localhost:8080/createProgramGroup
     */
    router.post('/createProgramGroup', apiProgramGroup.addProgramGroup);

    /**
     *  删除组及其所有子组的 API接口,对应前端请求url为 http://localhost:8080/deleteProgramGroup
     */
    router.post('/deleteProgramGroup', apiProgramGroup.deleteProgramGroup);

    /*************************************节目*****************************************************/
    /**
     *  新建节目,对应前端请求url为 http://localhost:8080/newProgram
     */
    router.post('/newProgram', apiProgram.newProgram);

    /**
     *  更新节目,对应前端请求url为 http://localhost:8080/updateProgram
     */
    router.post('/updateProgram', apiProgram.updateProgram);

    /**
     *  获取节目列表,对应前端请求url为 http://localhost:8080/queryProgram
     */
    router.get('/queryProgram', apiProgram.getPrograms);

    /**
     *  获取节目详细配置数据,对应前端请求url为 http://localhost:8080/getProgramEditData
     */
    router.get('/getProgramEditData', apiProgram.getProgramEditDataByProgramId);
    /**
     * 批量删除节目,对应前端请求url为 http://localhost:8080/deletePrograms
     */
    router.delete('/deletePrograms', apiProgram.deletePrograms);

    /*************************************节目发布*****************************************************/
    /**
     *  Web发布节目,对应前端请求url为 http://localhost:8080/createPublish
     */
    router.post('/createPublish', apiPublish.createPublish);

    /**
     * 删除发布计划
     */
    router.delete('/deletePublish', apiPublish.deleteServerPublishById);

    /*************************************推送消息*****************************************************/
    /**
     *  登录请求,对应前端请求url为 http://localhost:8080/publishCmd
     */
    router.post('/publishCmd', apiCmd.publishCmd);

    /**
     *  获取所有已发布节目数据,对应前端请求url为 http://localhost:8080/getAllServerPublishes
     */
    router.get('/getAllServerPublishes', apiPublish.getAllPublishes);

    /*************************************操作日志*****************************************************/
    /**
     *  获取所有模板,对应前端请求url为 http://localhost:8080/getOperationRecord
     */
    router.get('/getOperationRecord', apiUserRecord.getOperationRecord);

    /**
     * 实现一个全局的 404 错误处理。当用户请求的路径不匹配任何已定义的路由时，这个路由就会被调用，从而返回一个 404 响应
     */
    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    // Set up your Pipeline with any middleware you want to use and set the
    // router as the handler.
    return const Pipeline()
        .addMiddleware(corsMiddleware) // 添加 CORS 中间件
        .addMiddleware(logRequests())
        .addHandler(router.call);
  }

  /**
   * 启动本地服务
   */
  void startServer(String deviceIp, int serverPort) async {
    bool logging = true;
    var pipeline = const shelf.Pipeline()
        .addMiddleware(corsMiddleware) // 添加 CORS 中间件
        .addMiddleware(shelf.logRequests());
    // if (logging) {
    //   pipeline = pipeline.addMiddleware(shelf.logRequests());
    // }
    String? defaultDoc = _defaultDoc;
    //把前端页面放到本地
    ///  sdcard/snapVisonWeb/files
    ///  F:\\Work\\Project Flutter\\snap_vison_client\\example\\files  家里办公电脑
    ///  E:\\WorkSpace\\flutter-project\\snap-vision-client\\example\\files 公司办公电脑
    final localPath = await getApplicationDocumentsDirectory();///data/user/0/com.vinda.snap_vison_client/app_flutte
    print("localpPath: $localPath");
    String localWebPath = '${localPath.path}/${AppConfig().webVersion}/web';
    if (DeviceInfo.getUserName() == "MSI") {
      localWebPath = 'F:\\Work\\Project Flutter\\snap_vison_client\\example\\files';
    }
    final staticHandler = pipeline.addHandler(
        createStaticHandler(localWebPath, defaultDocument: defaultDoc));
    //上传的图片资源路径
    final localImageResourcePath =
        await FilePathManager.getUploadResourceDirectory("image");
    final staticImageResourceHandler =
        pipeline.addHandler(createStaticHandler(localImageResourcePath));
    //上传的视频资源路径
    final localVideoResourcePath =
        await FilePathManager.getUploadResourceDirectory("video");
    final staticVideResourceHandler =
        pipeline.addHandler(createStaticHandler(localVideoResourcePath));
    //合并Handler
    Handler cascadeHandler = Cascade()
        .add(staticHandler)
        .add(staticImageResourceHandler)
        .add(staticVideResourceHandler)
        .add(handler)
        .handler; // 合并静态资源、路由、websocket

    io.serve(cascadeHandler, deviceIp, serverPort).then((server) {
      print('Serving at http://${server.address.host}:${server.port}');
    });
  }

  shelf.Handler corsMiddleware(shelf.Handler innerHandler) {
    return (shelf.Request request) async {
      final response = await innerHandler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': 'http://localhost:8666', // 允许的来源
        'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization', // 允许的请求头
      });
    };
  }
}
