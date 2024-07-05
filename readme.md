Examples:
```dart
Future<FullDateZoo> calculateFullZoo(CachedCalcQuery query) async {
  return FullDateZoo.fromDate(
    query.params['dt'] as DateTime,
    query.params['tz'] as int,
  );
}

void basicCalculationTest() async {
  final fullTimeZooCache = CachedCalc<String, FullDateZoo>(
    paramsFactory: (key) {
      final cdt = CDT.fromString(key);
      return {
        'dt': cdt.toDateTime(),
        'tz': cdt.timeZone,
      };
    },
    task: calculateFullZoo,
  );

  const dates = <CDT>[
    CDT(
      year: 2001,
      month: 11,
      day: 19,
      hour: 13,
      minute: 25,
      timeZone: 6,
    ),
    CDT(
      year: 1990,
      month: 1,
      day: 28,
      hour: 0,
      minute: 2,
      timeZone: 2,
    ),
  ];

  for (int i = 0; i < dates.length; i++) {
    fullTimeZooCache.prepare(dates[i].toString()).listen((state) {
      //
      if (state.status == CachedCalcStatus.completed) {
        print(state.data as FullDateZoo);
      }
    });
  }

  for (int i = 0; i < dates.length; i++) {
    fullTimeZooCache.run(dates[i].toString());
  }
}
```