import 'package:flutter/foundation.dart';

@immutable
abstract class TweetState {}

class InitialState extends TweetState {}

/// The state when a tweet has been updated and needs to be rebuilt.
class UpdatedTweetState extends TweetState {}

/// The state when a tweet is currently being translated.
class TranslatingTweetState extends TweetState {}
