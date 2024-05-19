import 'package:mongo_dart/mongo_dart.dart';
import 'package:rabenkorb/abstracts/log_sink.dart';
import 'package:rabenkorb/models/app_info.dart';
import 'package:rabenkorb/models/log_data.dart';
import 'package:rabenkorb/services/core/environment_service.dart';
import 'package:watch_it/watch_it.dart';

class MongoDbSink implements LogSinks {
  static const String _mongoAppDataDatabase = "app-data";
  static const String _mongoLogCollection = "logs";
  static const String _mongoAppInfoCollection = "app-info";

  String get _mongoConnectionString => "${di<EnvironmentService>().mongoConnectionString}/$_mongoAppDataDatabase";
  final bool hasConnectionString = di<EnvironmentService>().hasConnectionString;

  @override
  Future<void> sendAppInfo(AppInfo appInfo) async {
    if (!hasConnectionString) {
      return;
    }
    final logCollection = await _getLogCollection(_mongoAppInfoCollection);
    final serializedData = appInfo.toJson();
    await logCollection.insertOne(serializedData);
  }

  @override
  Future<void> sendLog(LogData logData) async {
    if (!hasConnectionString) {
      return;
    }
    final logCollection = await _getLogCollection(_mongoLogCollection);
    final serializedData = logData.toJson();
    await logCollection.insertOne(serializedData);
  }

  Future<DbCollection> _getLogCollection(String collection) async {
    var db = await _createConnection();
    return db.collection(collection);
  }

  Future<Db> _createConnection() async {
    var db = await Db.create(_mongoConnectionString);
    await db.open();
    return db;
  }
}
