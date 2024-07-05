import 'dart:isolate';

class CachedCalcQuery {
  const CachedCalcQuery({
    required this.params,
    required this.port,
  });

  final dynamic params;
  final SendPort port;
}
