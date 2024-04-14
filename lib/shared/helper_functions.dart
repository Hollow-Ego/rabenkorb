import 'package:rabenkorb/services/state/loading_state.dart';
import 'package:watch_it/watch_it.dart';

Future<T> doWithLoadingIndicator<T>(Future<T> Function() operation) async {
  try {
    di<LoadingIndicatorState>().start();
    final result = await operation();
    return result;
  } finally {
    di<LoadingIndicatorState>().stop();
  }
}
