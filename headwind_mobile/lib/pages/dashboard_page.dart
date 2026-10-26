
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../provider/app_state.dart';
import 'alert_list_page.dart';
import 'job_list_page.dart';
import 'scan_page.dart';
import 'setting_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final appState = context.watch<AppState>();
    final pages = [
      _DashboardView(appState: appState),
      const JobListPage(),
      const AlertListPage(),
      const ScanPage(),
      const SettingPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(s.dashboard),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: Icon(
                appState.connected ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: appState.connected ? Colors.green : Colors.grey,
              ),
              label: Text(appState.connected ? s.online : s.offline, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: s.dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.list_alt), label: s.jobQueue),
          BottomNavigationBarItem(icon: const Icon(Icons.notifications), label: s.alert),
          BottomNavigationBarItem(icon: const Icon(Icons.qr_code_scanner), label: s.scan),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: s.setting),
        ],
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  final AppState appState;
  const _DashboardView({required this.appState});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    if (!appState.connected) {
      return Center(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(s.notConnected, textAlign: TextAlign.center)),
      );
    }
    final unconfirmed = appState.alerts.where((a) => !a.confirmed).length;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(children: [
          _StatCard(label: s.alert, value: appState.alerts.length.toString(), icon: Icons.notifications),
          _StatCard(label: s.unconfirmed, value: unconfirmed.toString(), icon: Icons.error_outline),
          _StatCard(label: s.jobQueue, value: appState.jobs.length.toString(), icon: Icons.list_alt),
        ]),
        const SizedBox(height: 8),
        Text(s.recentAlerts, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 4),
        if (appState.alerts.isEmpty)
          Padding(padding: const EdgeInsets.all(16), child: Text(s.noAlerts, textAlign: TextAlign.center))
        else
          ...appState.alerts.take(5).map((a) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  dense: true,
                  leading: Icon(a.confirmed ? Icons.check_circle : Icons.warning,
                      color: a.confirmed ? Colors.green : Colors.orange),
                  title: Text(a.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(a.machineId),
                ),
              )),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Icon(icon, color: const Color(0xFF1F5EFF)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]),
        ),
      ),
    );
  }
}
