import 'package:rxdart/rxdart.dart';

class LoadingIndicatorState {
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoading => _isLoading.stream;

  void start() {
    _isLoading.add(true);
  }

  void stop() {
    _isLoading.add(false);
  }
}
