
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants.dart';
import 'core/models.dart';
import 'core/offline/offline_store.dart';
import 'provider/auth_state.dart';
import 'provider/app_state.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedUrl = prefs.getString('serverUrl');
  if (savedUrl != null && savedUrl.isNotEmpty) {
    AppConstants.serverBaseUrl = savedUrl;
  }
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([SnRecordSchema, CacheJobSchema, CacheAlertSchema], directory: dir.path);
  runApp(HeadwindApp(prefs: prefs, offline: OfflineStoreService(isar)));
}

class HeadwindApp extends StatelessWidget {
  final SharedPreferences prefs;
  final OfflineStoreService offline;
  const HeadwindApp({super.key, required this.prefs, required this.offline});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => AppState(offline: offline, lang: prefs.getString('lang') ?? 'zh')),
        Provider.value(value: prefs),
      ],
      child: Builder(builder: (context) {
        final appState = Provider.of<AppState>(context);
        return MaterialApp(
          title: 'HeadWind管家',
          locale: appState.locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('zh'), Locale('zh', 'TW'), Locale('en')],
          theme: ThemeData(colorSchemeSeed: const Color(0xFF1F5EFF), useMaterial3: true),
          home: const SplashPage(),
        );
      }),
    );
  }
}
