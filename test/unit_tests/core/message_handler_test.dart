import 'package:flutter_test/flutter_test.dart';
import 'package:harpy/core/message_handler.dart';

void main() {
  group('message handler', () {
    test('triggers listener immediately when a single message gets added', () {
      String receivedMessage;

      void listener(String message) => receivedMessage = message;

      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: listener,
      );

      messageHandler.add('first message');

      expect(receivedMessage, 'first message');
    });

    test('showingMessage is false when a message has not been added', () {
      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: (String message) {},
      );

      expect(messageHandler.showingMessage, isFalse);
    });

    test('showingMessage is true after a message has been added', () {
      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: (String message) {},
      );

      messageHandler.add('new message');

      expect(messageHandler.showingMessage, isTrue);
    });

    test('showingMessage is false after a single message gets hidden', () {
      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: (String message) {},
      );

      messageHandler.add('new message');
      messageHandler.hide();

      expect(messageHandler.showingMessage, isFalse);
    });

    test('adds succeeding message into queue', () {
      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: (String message) {},
      );

      messageHandler..add('first message')..add('second message');

      expect(messageHandler.queue.length, 1);
    });

    test(
        'triggers listener with second message after the first one gets hidden',
        () {
      String receivedMessage;

      void listener(String message) => receivedMessage = message;

      final MessageHandler messageHandler = MessageHandler(
        onShowMessage: listener,
      );

      messageHandler
        ..add('first message')
        ..add('second message')
        ..hide();

      expect(messageHandler.showingMessage, isTrue);
      expect(receivedMessage, 'second message');
    });
  });
}
