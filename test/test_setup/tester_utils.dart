import 'package:flutter_test/flutter_test.dart';

import 'prime_assets.dart';

Future<void> primeAssetsAndSettle(WidgetTester tester) async {
  await primeAssets(tester);
  await tester.pumpAndSettle();
}
