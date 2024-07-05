// import 'package:compute/compute.dart';
import 'package:flutter/foundation.dart';
import 'model/cached_calc_query.dart';
import 'model/cached_calc_state.dart';
import 'model/cached_calc_status.dart';

Future<void> cachedCalcExecute(
  Future<dynamic> Function(CachedCalcQuery) task,
  CachedCalcQuery query,
) async {
  await compute(
    _CachedCalc,
    _CachedCalcExecData(task: task, query: query),
  );
}

class _CachedCalcExecData {
  _CachedCalcExecData({
    required this.task,
    required this.query,
  });
  final Future<dynamic> Function(CachedCalcQuery) task;
  final CachedCalcQuery query;
}

Future<void> _CachedCalc(_CachedCalcExecData data) async {
  try {
    final result = await data.task(data.query);
    data.query.port.send(
      CachedCalcState(
        status: CachedCalcStatus.completed,
        data: result,
      ),
    );
  } catch (e) {
    data.query.port.send(
      CachedCalcState(
        status: CachedCalcStatus.error,
        data: e,
      ),
    );
  }
}
