
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';

@collection
class SnRecord {
  Id id = Isar.autoIncrement;
  late String recordId;
  late String code;
  late String actionType;
  late DateTime ts;
  bool synced = false;

  SnRecord({required this.code, required this.actionType, required this.ts, this.synced = false}) {
    recordId = const Uuid().v4();
  }
}

@collection
class CacheJob {
  Id id = Isar.autoIncrement;
  late String jobId;
  late String machineId;
  late String status;
  late DateTime createTime;

  CacheJob({required this.jobId, required this.machineId, required this.status}) {
    createTime = DateTime.now();
  }
}

@collection
class CacheAlert {
  Id id = Isar.autoIncrement;
  late String alertId;
  late String machineId;
  late String content;
  bool confirmed = false;
  late DateTime ts;

  CacheAlert({required this.alertId, required this.machineId, required this.content, this.confirmed = false}) {
    ts = DateTime.now();
  }
}
