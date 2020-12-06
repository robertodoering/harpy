import 'package:flutter/foundation.dart';

@immutable
abstract class ComposeState {}

class InitialComposeTweetState extends ComposeState {}

class UpdatedComposeTweetState extends ComposeState {}

class UploadingMediaState extends ComposeState {}

class SendingTweetState extends ComposeState {}
