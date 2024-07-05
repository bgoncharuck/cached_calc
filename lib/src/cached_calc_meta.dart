import 'dart:async';
import 'dart:isolate';
import 'model/cached_calc_state.dart';
import 'model/cached_calc_status.dart';

class CachedCalcMeta<K, R> {
  final Map<K, R?> results = {};
  final Map<K, CachedCalcStatus> status = {};

  final Map<K, StreamController<CachedCalcState>> _controllers = {};
  Stream<CachedCalcState> streamOf(K key) => _controllers[key]!.stream;

  final Map<K, ReceivePort> _ports = {};
  SendPort sendPortOf(K key) => _ports[key]!.sendPort;

  bool prepare(K key) {
    if (_ports.containsKey(key)) {
      return false;
    }

    results[key] = null;
    status[key] = CachedCalcStatus.notStarted;
    _controllers[key] = StreamController<CachedCalcState>.broadcast();
    _ports[key] = ReceivePort();

    _ports[key]!.listen((event) {
      if (event is CachedCalcState) {
        status[key] = event.status;
        if (event.status == CachedCalcStatus.completed) {
          results[key] = event.data as R;
        }

        _controllers[key]!.add(event);
      }
    });

    return true;
  }
}
