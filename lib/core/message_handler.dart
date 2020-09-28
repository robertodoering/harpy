import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef OnShowMessage = void Function(String message);

/// Receives String messages and queues them.
///
/// Triggers the [onShowMessage] when a message should show. A currently showing
/// message can be hidden using [hide] to allow for the next messages in queue
/// to trigger the [onShowMessage].
class MessageHandler {
  MessageHandler({
    @required this.onShowMessage,
  });

  final OnShowMessage onShowMessage;

  @visibleForTesting
  Queue<String> get queue => _queue;
  final Queue<String> _queue = Queue<String>();

  bool get showingMessage => _showingMessage;
  bool _showingMessage = false;

  /// Adds a new message into the message [queue].
  void add(String message) {
    if (_showingMessage) {
      _queue.add(message);
    } else {
      onShowMessage(message);
      _showingMessage = true;
    }
  }

  /// Calls the [onShowMessage] callback with the next message in the [queue] if
  /// it is not empty.
  void hide() {
    if (_queue.isNotEmpty) {
      onShowMessage(_queue.removeFirst());
    } else {
      _showingMessage = false;
    }
  }
}
