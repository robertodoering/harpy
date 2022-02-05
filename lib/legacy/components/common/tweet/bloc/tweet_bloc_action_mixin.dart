part of 'tweet_bloc.dart';

/// The callback definition for tweet actions.
typedef OnTweetAction = void Function(TweetAction action);

mixin TweetBlocActionCallback on Bloc<TweetEvent, TweetState> {
  final List<OnTweetAction> callbacks = [];

  void addCallback(OnTweetAction onTweetAction) {
    callbacks.add(onTweetAction);
  }

  void removeCallback(OnTweetAction onTweetAction) {
    callbacks.remove(onTweetAction);
  }

  void _invoke(TweetAction action) {
    for (final callback in callbacks) {
      callback(action);
    }
  }
}

/// Actions that can register a callback in the [TweetBlocActionCallback].
///
/// Only [translate] is used at the moment.
enum TweetAction {
  translate,
}
