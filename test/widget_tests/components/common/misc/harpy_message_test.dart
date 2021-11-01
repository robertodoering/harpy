import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

void main() {
  group('harpy message', () {
    testWidgets('display a snack bar when show is called', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HarpyMessage(
            child: Container(),
          ),
        ),
      );

      tester.state<HarpyMessageState>(find.byType(HarpyMessage)).show('hello');

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('message service', () {
    testWidgets('uses the harpy message global key to show message',
        (tester) async {
      const messageService = MessageService();

      await tester.pumpWidget(
        MaterialApp(
          home: HarpyMessage(
            child: Container(),
          ),
        ),
      );

      messageService.show('hello');

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
