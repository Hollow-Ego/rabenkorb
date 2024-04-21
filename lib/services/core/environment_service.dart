class EnvironmentService {
  String environment = const String.fromEnvironment('env');

  get isDebug => environment == "dev";
}
