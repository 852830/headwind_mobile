
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../l10n/app_strings.dart';
import '../provider/app_state.dart';
import '../provider/auth_state.dart';
import 'login_qr_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final TextEditingController _serverCtrl;

  @override
  void initState() {
    super.initState();
    _serverCtrl = TextEditingController(text: AppConstants.serverBaseUrl);
  }

  @override
  void dispose() {
    _serverCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveServer() async {
    final url = _serverCtrl.text.trim();
    if (url.isEmpty) return;
    AppConstants.serverBaseUrl = url;
    await context.read<SharedPreferences>().setString('serverUrl', url);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppStrings.of(context).save)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final appState = context.watch<AppState>();
    final authState = context.read<AuthState>();
    final langValue = appState.locale.languageCode == 'en'
        ? 'en'
        : (appState.locale.countryCode == 'TW' ? 'zh-TW' : 'zh');
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _serverCtrl,
            decoration: InputDecoration(labelText: s.serverUrl, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saveServer, child: Text(s.save)),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: langValue,
            decoration: InputDecoration(labelText: s.language, border: const OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'zh', child: Text('简体中文')),
              DropdownMenuItem(value: 'zh-TW', child: Text('繁體中文')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (v) {
              if (v == null) return;
              appState.setLocale(v);
              context.read<SharedPreferences>().setString('lang', v);
            },
          ),
          const SizedBox(height: 24),
          Text('${s.version} 1.0.0', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          FilledButton.tonal(
            style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              authState.logout();
              appState.disconnect();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginQrPage()),
              );
            },
            child: Text(s.logout),
          ),
        ],
      ),
    );
  }
}
