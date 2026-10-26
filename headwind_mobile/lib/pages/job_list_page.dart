
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../provider/app_state.dart';
import '../widgets/status_badge.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final jobs = context.watch<AppState>().jobs;
    if (jobs.isEmpty) {
      return Center(child: Text(s.noJobs));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: jobs.length,
      itemBuilder: (ctx, i) {
        final j = jobs[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.print),
            title: Text('${s.job}: ${j.jobId}'),
            subtitle: Text('${s.machine}: ${j.machineId}'),
            trailing: StatusBadge(text: j.status, color: Colors.blue),
          ),
        );
      },
    );
  }
}
