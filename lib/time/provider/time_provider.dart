import 'package:flutter_riverpod/legacy.dart';

final timeProvider = StateProvider<Duration>(
  (ref) => Duration(seconds: 5),
);
