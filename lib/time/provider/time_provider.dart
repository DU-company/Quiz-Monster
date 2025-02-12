import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StateProvider<Duration>(
  (ref) => Duration(seconds: 5),
);
