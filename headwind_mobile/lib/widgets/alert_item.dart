
import 'package:flutter/material.dart';
import '../core/models.dart';
import '../l10n/app_strings.dart';
import 'status_badge.dart';

class AlertItem extends StatelessWidget {
  final CacheAlert alert;
  final VoidCallback onConfirm;
  const AlertItem({super.key, required this.alert, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(alert.machineId, style: const TextStyle(fontWeight: FontWeight.w600)),
            StatusBadge(
              text: alert.confirmed ? s.confirmed : s.unconfirmed,
              color: alert.confirmed ? Colors.blue : Colors.red,
            ),
          ]),
          const SizedBox(height: 6),
          Text(alert.content),
          const SizedBox(height: 6),
          Text(alert.ts.toLocal().toString().substring(0, 16),
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          if (!alert.confirmed)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onConfirm,
                icon: const Icon(Icons.check),
                label: Text(s.confirmAlert),
              ),
            ),
        ]),
      ),
    );
  }
}
