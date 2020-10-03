import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/components/common/misc/harpy_message.dart';
import 'package:harpy/core/message_service.dart';

void main() {
  group('harpy message', () {
    testWidgets('display a snack bar when show is called',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: HarpyMessage(
          child: Container(),
        ),
      ));

      final HarpyMessageState state = tester.state(find.byType(HarpyMessage));

      state.show('hello');

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('message service', () {
    testWidgets('uses the harpy message global key to show message',
        (WidgetTester tester) async {
      final MessageService messageService = MessageService();

      await tester.pumpWidget(MaterialApp(
        home: HarpyMessage(
          child: Container(),
        ),
      ));

      messageService.show('hello');

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
