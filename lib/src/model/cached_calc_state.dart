import 'cached_calc_status.dart';

class CachedCalcState {
  const CachedCalcState({
    required this.status,
    required this.data,
  });

  final CachedCalcStatus status;
  final dynamic data;
}
