
import 'package:isar/isar.dart';
import '../models.dart';

class OfflineStoreService {
  final Isar isar;
  OfflineStoreService(this.isar);

  Future<void> cacheSnRecord(SnRecord rec) => isar.writeTxn(() => isar.snRecords.put(rec));

  Future<List<SnRecord>> getPendingSn() => isar.snRecords.filter().syncedEqualTo(false).findAll();

  Future<void> markSnSynced(String recordId) async {
    final item = await isar.snRecords.filter().recordIdEqualTo(recordId).findFirst();
    if (item != null) {
      item.synced = true;
      await isar.writeTxn(() => isar.snRecords.put(item));
    }
  }

  Future<void> cacheAlert(CacheAlert a) => isar.writeTxn(() => isar.alerts.put(a));

  Future<void> updateAlertConfirmed(String alertId) async {
    final item = await isar.alerts.filter().alertIdEqualTo(alertId).findFirst();
    if (item != null) {
      item.confirmed = true;
      await isar.writeTxn(() => isar.alerts.put(item));
    }
  }

  Future<List<CacheJob>> getCachedJobs() => isar.jobs.where().findAll();
}
