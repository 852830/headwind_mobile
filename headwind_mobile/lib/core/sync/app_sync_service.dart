
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants.dart';
import '../models.dart';
import '../auth/mobile_auth_service.dart';
import '../offline/offline_store.dart';

class AppSyncService {
  WebSocketChannel? _ws;
  bool get isOnline => _ws != null;

  Future<void> connect(String token, {required void Function(Map<String, dynamic>) onEvent}) async {
    try {
      final base = AppConstants.serverBaseUrl;
      final wsUrl = '${base.replaceFirst(RegExp('^http'), 'ws')}${AppConstants.wsPath}?token=$token';
      final ws = WebSocketChannel.connect(Uri.parse(wsUrl));
      await ws.ready;
      _ws = ws;
      ws.stream.listen((raw) {
        final d = jsonDecode(raw.toString()) as Map<String, dynamic>;
        onEvent(d);
      }, onError: (_) {}, onDone: () {
        if (identical(_ws, ws)) _ws = null;
      });
    } catch (_) {
      _ws = null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> submitScan(String code, String actionType, AppSession? session, OfflineStoreService offline) async {
    if (session == null || !isOnline) {
      await offline.cacheSnRecord(SnRecord(code: code, actionType: actionType, ts: DateTime.now()));
      return {'ok': false, 'offline': true};
    }
    try {
      final res = await http
          .post(
            Uri.parse('${AppConstants.serverBaseUrl}${AppConstants.apiScan}'),
            headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${session.token}'},
            body: jsonEncode({'code': code, 'action': actionType}),
          )
          .timeout(const Duration(seconds: 8));
      final d = jsonDecode(res.body);
      return d is Map<String, dynamic> ? d : {'ok': res.statusCode == 200};
    } catch (_) {
      await offline.cacheSnRecord(SnRecord(code: code, actionType: actionType, ts: DateTime.now()));
      return {'ok': false, 'offline': true};
    }
  }

  Future<void> syncPending(OfflineStoreService offline, AppSession session) async {
    final pending = await offline.getPendingSn();
    for (final item in pending) {
      try {
        final r = await submitScan(item.code, item.actionType, session, offline);
        if (r['ok'] == true) await offline.markSnSynced(item.recordId);
      } catch (_) {}
    }
  }

  void close() {
    _ws?.sink.close();
    _ws = null;
  }
}
