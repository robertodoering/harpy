import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';

final translateServiceProvider = Provider(
  (ref) => TranslateService(),
  name: 'TranslateServiceProvider',
);
