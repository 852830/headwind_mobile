
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../provider/app_state.dart';
import '../widgets/alert_item.dart';

class AlertListPage extends StatelessWidget {
  const AlertListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final appState = context.watch<AppState>();
    final alerts = appState.alerts;
    if (alerts.isEmpty) {
      return Center(child: Text(s.noAlerts));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: alerts.length,
      itemBuilder: (ctx, i) {
        final a = alerts[i];
        return AlertItem(alert: a, onConfirm: () => appState.confirmAlert(a));
      },
    );
  }
}
