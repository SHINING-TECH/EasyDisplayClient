import 'package:flutter/material.dart';

// 全局变量，用于保存当前语言环境，默认英文
String _currentLocale = 'en';

class L10n {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'serverPath': 'Server Path:',
      'serverUseTips': 'For the best experience, please use Chrome to log in.',
      'serverUseTips1': 'This system must be accessed from a computer on the same local network.',
      'serverUseTips2': 'Default login: ',
      'language': 'Language',
      'chinese': '中文',
      'english': 'English',
      'ja': '日本語',
      'heartbeat_interval': 'Heartbeat Interval',
      'seconds': 'seconds',
      'general_settings': 'General Settings',
      'platform_address': 'Server Address',
      'service_settings': 'Server Settings',
      'service_type': 'service_type',
      'host': 'Client&Server',
      'slave': 'Client',
      'version': 'Version:',
      'psw_dialog_title': 'Enter Password',
      'psw_dialog_show_psw': 'Show Password',
      'psw_dialog_hide_psw': 'Hide Password',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'password_error': 'Incorrect password',
      //日志记录
      'log_publish_cmd':  'Publish Command',
      'log_publish_cmd_exit_app':   'Exit Application',
      'log_upload_resource':  'Upload Resource',
      'log_delete_resource': 'Delete Resource',
      'log_delete_program': 'Delete Program',
      'log_create_program': 'Create Program',
      'log_create_program_group': 'Create Program Group',
      'log_delete_program_group': 'Delete Program Group',
      'log_publish': 'Publish',
      'log_terminal_id': 'Terminal ID',
      'log_program_name': 'Program Name',
      'log_delete_publish': 'Delete Publish',
      'log_create_resource_group': 'Create Resource Group',
      'log_delete_resource_group': 'Delete Resource Group',
      'log_delete_template': 'Delete Template',
      'log_create_template': 'Create Template',
      'log_update_template': 'Update Template',
      'log_create_template_group': 'Create Template Group',
      'log_delete_template_group': 'Delete Template Group',
      'log_modify_ter_params': 'Modify Terminal Parameters',
      'log_reset_psw': 'Reset Password',
      'log_change_psw': 'Change Password',
      'log_login': 'Login'

    },
    'zh': {
      'settings': '设置',
      'serverPath': '服务器地址:',
      'serverUseTips': '为了更好的体验,建议您使用Chrome浏览器登录发布平台',
      'serverUseTips1': '必须从同一局域网内的计算机访问此系统。',
      'serverUseTips2': '默认登录：',
      'language': '语言',
      'chinese': '中文',
      'english': 'English',
      'ja': '日本語',
      'heartbeat_interval': '心跳间隔',
      'seconds': '秒',
      'general_settings': '通用设置',
      'platform_address': '平台地址',
      'service_settings': '服务设置',
      'service_type': '服务类型',
      'host': '客户端+服务端',
      'slave': '客户端',
      'version': '版本:',
      'psw_dialog_title': '输入密码:',
      'psw_dialog_show_psw': '显示密码',
      'psw_dialog_hide_psw': '隐藏密码',
      'confirm': '确认',
      'cancel': '取消',
      'psw_error_tip': '密码错误',
      //日志记录
      'log_publish_cmd': '发布命令',
      'log_publish_cmd_exit_app': '退出应用',
      'log_upload_resource': '上传资源',
      'log_delete_resource': '删除资源',
      'log_delete_program': '删除程序',
      'log_create_program': '创建节目',
      'log_create_program_group': '创建节目组',
      'log_delete_program_group': '删除节目组',
      'log_publish':  '发布',
      'log_terminal_id':  '终端ID',
      'log_program_name':  '程序名称',
      'log_delete_publish':  '删除发布',
      'log_create_resource_group':  '创建资源组',
      'log_delete_resource_group':  '删除资源组',
      'log_delete_template':  '删除模板',
      'log_create_template':  '创建模板',
      'log_update_template':  '更新模板',
      'log_create_template_group':  '创建模板组',
      'log_delete_template_group':  '删除模板组',
      'log_modify_ter_params':  '修改终端参数',
      'log_reset_psw':  '重置密码',
      'log_change_psw':  '修改密码',
      'log_login':  '登录',
    },
    'ja': {
      'settings': '設定',
      'serverPath': 'サーバーアドレス:',
      'serverUseTips': 'より良い体験のため、Chromeブラウザでプラットフォームにログインすることをお勧めします。',
      'serverUseTips1': 'このシステムは同じローカルネットワーク内のコンピュータからアクセスする必要があります。',
      'serverUseTips2': 'デフォルトログイン：',
      'language': '言語',
      'chinese': '中文',
      'english': 'English',
      'ja': '日本語',
      'heartbeat_interval': 'ハートビート間隔',
      'seconds': '秒',
      'general_settings': '一般設定',
      'platform_address': 'プラットフォームアドレス',
      'service_settings': 'サービス設定',
      'service_type': 'サービスタイプ',
      'host': 'クライアント+サーバー',
      'slave': 'クライアント',
      'version': 'バージョン:',
      'psw_dialog_title': 'パスワードを入力:',
      'psw_dialog_show_psw': 'パスワードを表示',
      'psw_dialog_hide_psw': 'パスワードを非表示',
      'confirm': '確認',
      'cancel': 'キャンセル',
      'psw_error_tip': 'パスワードが間違っています',
      //日志记录
      'log_publish_cmd':  '公開コマンド',
      'log_publish_cmd_exit_app':   'アプリケーションを終了',
      'log_upload_resource':  'リソースをアップロード',
      'log_delete_resource': 'リソースを削除',
      'log_delete_program': 'プログラムを削除',
      'log_create_program': 'プログラムを作成',
      'log_create_program_group': 'プログラムグループを作成',
      'log_delete_program_group': 'プログラムグループを削除',
      'log_publish': '公開',
      'log_terminal_id': '端末ID',
      'log_program_name': 'プログラム名',
      'log_delete_publish': '公開を削除',
      'log_create_resource_group': 'リソースグループを作成',
      'log_delete_resource_group': 'リソースグループを削除',
      'log_delete_template': 'テンプレートを削除',
      'log_create_template': 'テンプレートを作成',
      'log_update_template': 'テンプレートを更新',
      'log_create_template_group': 'テンプレートグループを作成',
      'log_delete_template_group': 'テンプレートグループを削除',
      'log_modify_ter_params': '端末パラメータを変更',
      'log_reset_psw': 'パスワードをリセット',
      'log_change_psw': 'パスワードを変更',
      'log_login': 'ログイン'

    },
  };

  static String getString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  // 新增不需要 context 的 getString 函数
  static String getStringWithoutContext(String key) {
    return _localizedValues[_currentLocale]?[key] ?? _localizedValues['en']![key]!;
  }

  // 新增设置当前语言环境的函数
  static void setLocale(String locale) {
    print("设置当前语言环境:$locale");
    _currentLocale = locale;
  }
} 