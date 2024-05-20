import 'package:rabenkorb/shared/environments.dart';

class EnvironmentService {
  static const String _connectionStringEnvName = 'MONGO_CONNECTION_STRING';

  final List<String> _debugEnvironments = [Environments.dev, Environments.qa];

  String environment = const String.fromEnvironment('env');
  bool hasConnectionString = const bool.hasEnvironment(_connectionStringEnvName);
  String mongoConnectionString = const String.fromEnvironment(_connectionStringEnvName);

  get isDebug => _debugEnvironments.contains(environment);
}
