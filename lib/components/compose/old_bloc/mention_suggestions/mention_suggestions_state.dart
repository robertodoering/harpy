import 'package:flutter/foundation.dart';

@immutable
abstract class MentionSuggestionsState {}

class InitialMentionSuggestionsState extends MentionSuggestionsState {}

class UpdatedSuggestionsState extends MentionSuggestionsState {}
