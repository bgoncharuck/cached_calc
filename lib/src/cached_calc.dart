import 'cached_calc_exec.dart';
import 'cached_calc_meta.dart';
import 'model/cached_calc_query.dart';
import 'model/cached_calc_state.dart';
import 'model/cached_calc_status.dart';

class CachedCalc<K, R> {
  CachedCalc({
    required this.paramsFactory,
    required this.task,
  });

  final meta = CachedCalcMeta<K, R>();
  final dynamic Function(K) paramsFactory;
  final Future<R> Function(CachedCalcQuery) task;

  bool hasResult(K key) {
    if (!meta.status.containsKey(key)) {
      return false;
    }

    if (meta.status[key] != CachedCalcStatus.completed) {
      return false;
    }

    if (meta.results[key] == null) {
      return false;
    }

    return true;
  }

  R? result(K key) {
    return meta.results[key];
  }

  Stream<CachedCalcState> prepare(K key) {
    meta.prepare(key);
    return meta.streamOf(key);
  }

  void run(K key) {
    if (!meta.status.containsKey(key)) {
      return;
    }
    if (meta.status[key] == CachedCalcStatus.running) {
      return;
    }

    final params = paramsFactory(key);
    final query = CachedCalcQuery(
      port: meta.sendPortOf(key),
      params: params,
    );
    meta.status[key] = CachedCalcStatus.running;
    cachedCalcExecute(
      task,
      query,
    );
  }
}
