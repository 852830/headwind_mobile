
import 'package:flutter/widgets.dart';

class AppStrings {
  final String code;
  const AppStrings._(this.code);

  static AppStrings of(BuildContext context) {
    final loc = Localizations.localeOf(context);
    final code = loc.countryCode == 'TW' ? 'zh-TW' : loc.languageCode;
    return AppStrings._(_supported.contains(code) ? code : 'zh');
  }

  static const List<String> _supported = ['zh', 'zh-TW', 'en'];

  static const Map<String, Map<String, String>> _t = {
    'zh': {
      'splashLoading': '正在连接HeadWind…',
      'scanLogin': '扫码登录',
      'loginTip': '请扫描控制台/网页上的登录二维码，或点击下方测试登录',
      'testLogin': '测试登录（TEST123）',
      'loginFail': '登录失败，请检查服务地址',
      'online': '在线', 'offline': '离线',
      'dashboard': '看板', 'jobQueue': '任务队列', 'alert': '告警', 'scan': '扫码', 'setting': '设置',
      'noJobs': '暂无任务', 'noAlerts': '暂无告警',
      'notConnected': '未连接服务：请到【设置】填写服务地址（电脑局域网IP:8080）',
      'recentAlerts': '最新告警', 'unconfirmed': '未确认',
      'job': '任务', 'machine': '设备',
      'scanHint': '对准SN条码/二维码扫码，选择操作',
      'startJob': '启动任务', 'confirmAlert': '确认告警', 'cancel': '取消',
      'submitOk': '提交成功', 'submitFail': '提交失败',
      'offlineCached': '当前离线，已缓存到本地，联网后自动同步',
      'confirmed': '已确认',
      'serverUrl': '服务地址', 'save': '保存', 'language': '语言', 'version': '版本', 'logout': '退出登录',
    },
    'zh-TW': {
      'splashLoading': '正在連接HeadWind…',
      'scanLogin': '掃碼登入',
      'loginTip': '請掃描控制台/網頁上的登入 QRCode，或點擊下方測試登入',
      'testLogin': '測試登入（TEST123）',
      'loginFail': '登入失敗，請檢查伺服器位址',
      'online': '線上', 'offline': '離線',
      'dashboard': '儀表板', 'jobQueue': '任務佇列', 'alert': '警示', 'scan': '掃碼', 'setting': '設定',
      'noJobs': '暫無任務', 'noAlerts': '暫無警示',
      'notConnected': '未連線服務：請到【設定】填寫伺服器位址（電腦區域網路IP:8080）',
      'recentAlerts': '最新警示', 'unconfirmed': '未確認',
      'job': '任務', 'machine': '裝置',
      'scanHint': '對準SN條碼/QRCode掃描，選擇操作',
      'startJob': '啟動任務', 'confirmAlert': '確認警示', 'cancel': '取消',
      'submitOk': '提交成功', 'submitFail': '提交失敗',
      'offlineCached': '目前離線，已快取至本機，連線後自動同步',
      'confirmed': '已確認',
      'serverUrl': '伺服器位址', 'save': '儲存', 'language': '語言', 'version': '版本', 'logout': '登出',
    },
    'en': {
      'splashLoading': 'Connecting to HeadWind…',
      'scanLogin': 'QR Login',
      'loginTip': 'Scan the login QR from web console, or tap test login below',
      'testLogin': 'Test Login (TEST123)',
      'loginFail': 'Login failed, check server URL',
      'online': 'Online', 'offline': 'Offline',
      'dashboard': 'Dashboard', 'jobQueue': 'Jobs', 'alert': 'Alerts', 'scan': 'Scan', 'setting': 'Settings',
      'noJobs': 'No jobs', 'noAlerts': 'No alerts',
      'notConnected': 'Not connected: set server URL (PC LAN IP:8080) in Settings',
      'recentAlerts': 'Recent alerts', 'unconfirmed': 'Unconfirmed',
      'job': 'Job', 'machine': 'Machine',
      'scanHint': 'Scan SN barcode / QR to take action',
      'startJob': 'Start job', 'confirmAlert': 'Confirm alert', 'cancel': 'Cancel',
      'submitOk': 'Submitted', 'submitFail': 'Submit failed',
      'offlineCached': 'Offline: cached locally, auto sync when online',
      'confirmed': 'Confirmed',
      'serverUrl': 'Server URL', 'save': 'Save', 'language': 'Language', 'version': 'Version', 'logout': 'Logout',
    },
  };

  String _g(String k) => _t[code]?[k] ?? _t['zh']![k] ?? k;

  String get splashLoading => _g('splashLoading');
  String get scanLogin => _g('scanLogin');
  String get loginTip => _g('loginTip');
  String get testLogin => _g('testLogin');
  String get loginFail => _g('loginFail');
  String get online => _g('online');
  String get offline => _g('offline');
  String get dashboard => _g('dashboard');
  String get jobQueue => _g('jobQueue');
  String get alert => _g('alert');
  String get scan => _g('scan');
  String get setting => _g('setting');
  String get noJobs => _g('noJobs');
  String get noAlerts => _g('noAlerts');
  String get notConnected => _g('notConnected');
  String get recentAlerts => _g('recentAlerts');
  String get unconfirmed => _g('unconfirmed');
  String get job => _g('job');
  String get machine => _g('machine');
  String get scanHint => _g('scanHint');
  String get startJob => _g('startJob');
  String get confirmAlert => _g('confirmAlert');
  String get cancel => _g('cancel');
  String get submitOk => _g('submitOk');
  String get submitFail => _g('submitFail');
  String get offlineCached => _g('offlineCached');
  String get confirmed => _g('confirmed');
  String get serverUrl => _g('serverUrl');
  String get save => _g('save');
  String get language => _g('language');
  String get version => _g('version');
  String get logout => _g('logout');
}
