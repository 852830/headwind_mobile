
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../provider/app_state.dart';
import '../provider/auth_state.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _loading = false;
  String? _lastCode;

  Future<void> _submit(String code, String action) async {
    if (_loading) return;
    setState(() => _loading = true);
    final appState = context.read<AppState>();
    final authState = context.read<AuthState>();
    final res = await appState.sync.submitScan(code, action, authState.session, appState.offline);
    if (!mounted) return;
    final s = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['offline'] == true
          ? s.offlineCached
          : (res['ok'] == true ? s.submitOk : s.submitFail)),
    ));
    setState(() => _loading = false);
  }

  void _showActions(String code) {
    final s = AppStrings.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.play_arrow), title: Text(s.startJob),
              onTap: () { Navigator.pop(ctx); _submit(code, 'start_job'); }),
          ListTile(leading: const Icon(Icons.check_circle), title: Text(s.confirmAlert),
              onTap: () { Navigator.pop(ctx); _submit(code, 'confirm_alert'); }),
          ListTile(leading: const Icon(Icons.close), title: Text(s.cancel), onTap: () => Navigator.pop(ctx)),
        ]),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    for (final b in capture.barcodes) {
      final v = b.rawValue;
      if (v == null || v.isEmpty) continue;
      if (v == _lastCode) return;
      _lastCode = v;
      _showActions(v);
      return;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: Column(children: [
        Expanded(child: MobileScanner(controller: _controller, onDetect: _onDetect)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text(s.scanHint, textAlign: TextAlign.center),
            if (_loading) const Padding(padding: EdgeInsets.only(top: 8), child: CircularProgressIndicator()),
          ]),
        ),
      ]),
    );
  }
}
