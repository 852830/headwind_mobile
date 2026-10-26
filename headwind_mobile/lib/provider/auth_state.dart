
import 'package:flutter/foundation.dart';
import '../core/auth/mobile_auth_service.dart';

class AuthState extends ChangeNotifier {
  AppSession? _session;
  AppSession? get session => _session;
  bool get isLogin => _session != null;

  void setSession(AppSession? s) {
    _session = s;
    notifyListeners();
  }

  void logout() {
    _session = null;
    notifyListeners();
  }
}
