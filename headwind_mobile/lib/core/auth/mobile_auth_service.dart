
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AppSession {
  final String sessionId;
  final String token;
  final String uid;
  final Map<String, bool> perm;
  AppSession({required this.sessionId, required this.token, required this.uid, required this.perm});
}

class MobileAuthService {
  Future<AppSession?> exchangeSession(String qrToken) async {
    try {
      final res = await http
          .post(
            Uri.parse('${AppConstants.serverBaseUrl}${AppConstants.apiExchangeSession}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'qrToken': qrToken}),
          )
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final permRaw = d['perm'] as Map<String, dynamic>? ?? {};
        return AppSession(
          sessionId: d['sessionId']?.toString() ?? '',
          token: d['token']?.toString() ?? '',
          uid: d['uid']?.toString() ?? '',
          perm: permRaw.map((k, v) => MapEntry(k, v == true)),
        );
      }
    } catch (_) {}
    return null;
  }
}
