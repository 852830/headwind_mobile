
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../core/auth/mobile_auth_service.dart';
import '../l10n/app_strings.dart';
import '../provider/auth_state.dart';
import '../provider/app_state.dart';
import 'dashboard_page.dart';

class LoginQrPage extends StatefulWidget {
  const LoginQrPage({super.key});
  @override
  State<LoginQrPage> createState() => _LoginQrPageState();
}

class _LoginQrPageState extends State<LoginQrPage> {
  final MobileScannerController _controller = MobileScannerController();
  final MobileAuthService _auth = MobileAuthService();
  bool _loading = false;
  bool _handled = false;

  Future<void> _onScan(String token) async {
    if (_loading || _handled) return;
    _handled = true;
    setState(() => _loading = true);
    final session = await _auth.exchangeSession(token.trim());
    if (!mounted) return;
    if (session != null) {
      context.read<AuthState>().setSession(session);
      await context.read<AppState>().connect(session.token);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardPage()));
    } else {
      _handled = false;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.of(context).loginFail)));
    }
  }

  Future<void> _testLogin() => _onScan('TEST123');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.scanLogin)),
      body: Column(children: [
        Expanded(
          child: MobileScanner(controller: _controller, onDetect: (capture) {
            for (final b in capture.barcodes) {
              final v = b.rawValue;
              if (v != null && v.isNotEmpty) {
                _onScan(v);
                break;
              }
            }
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text(s.loginTip, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (_loading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(onPressed: _testLogin, icon: const Icon(Icons.flash_on), label: Text(s.testLogin)),
          ]),
        ),
      ]),
    );
  }
}
