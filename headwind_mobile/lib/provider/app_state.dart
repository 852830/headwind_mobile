
import 'package:flutter/widgets.dart';
import '../core/models.dart';
import '../core/offline/offline_store.dart';
import '../core/sync/app_sync_service.dart';

class AppState extends ChangeNotifier {
  final OfflineStoreService offline;
  final AppSyncService sync = AppSyncService();

  bool connected = false;
  Locale locale;
  final List<CacheAlert> alerts = [];
  final List<CacheJob> jobs = [];

  AppState({required this.offline, String lang = 'zh'}) : locale = _resolveLocale(lang);

  static Locale _resolveLocale(String code) {
    if (code == 'en') return const Locale('en');
    if (code == 'zh-TW') return const Locale('zh', 'TW');
    return const Locale('zh');
  }

  void setLocale(String code) {
    locale = _resolveLocale(code);
    notifyListeners();
  }

  Future<void> connect(String token) async {
    try {
      await sync.connect(token, onEvent: _handleEvent);
      connected = true;
    } catch (_) {
      connected = false;
    }
    notifyListeners();
  }

  void _handleEvent(Map<String, dynamic> d) {
    final type = d['type'];
    if (type == 'alert') {
      final data = d['data'] as Map<String, dynamic>? ?? const {};
      final a = CacheAlert(
        alertId: data['alertId']?.toString() ?? '',
        machineId: data['machineId']?.toString() ?? '',
        content: data['content']?.toString() ?? '',
        confirmed: data['confirmed'] == true,
      );
      a.ts = DateTime.tryParse(data['ts']?.toString() ?? '') ?? DateTime.now();
      alerts.insert(0, a);
      if (alerts.length > 50) alerts.removeRange(50, alerts.length);
      offline.cacheAlert(a);
    } else if (type == 'job') {
      final data = d['data'] as Map<String, dynamic>? ?? const {};
      jobs.insert(0, CacheJob(
        jobId: data['jobId']?.toString() ?? '',
        machineId: data['machineId']?.toString() ?? '',
        status: data['status']?.toString() ?? '',
      ));
      if (jobs.length > 50) jobs.removeRange(50, jobs.length);
    }
    notifyListeners();
  }

  Future<void> confirmAlert(CacheAlert a) async {
    a.confirmed = true;
    await offline.updateAlertConfirmed(a.alertId);
    notifyListeners();
  }

  void disconnect() {
    sync.close();
    connected = false;
    notifyListeners();
  }
}
