import 'package:rabenkorb/shared/environments.dart';

class EnvironmentService {
  final List<String> _debugEnvironments = [Environments.dev, Environments.prod];

  String environment = const String.fromEnvironment('env');

  get isDebug => _debugEnvironments.contains(environment);
}
