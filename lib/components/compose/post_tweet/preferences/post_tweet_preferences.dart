import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

part 'post_tweet_preferences.freezed.dart';
part 'post_tweet_preferences.g.dart';

final postTweetPreferencesProvider =
    StateNotifierProvider<PostTweetPreferencesNotifier, PostTweetPreferences>(
  (ref) => PostTweetPreferencesNotifier(
    preferences: ref.watch(
      preferencesProvider(ref.watch(authPreferencesProvider).userId),
    ),
  ),
  name: 'PostTweetPreferencesProvider',
);

class PostTweetPreferencesNotifier extends StateNotifier<PostTweetPreferences> {
  PostTweetPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          PostTweetPreferences(
            unrelatedMentions: preferences.getStringList(
              'unrelatedMentions',
              [],
            ),
          ),
        );

  /// Verifies that the new amount of unrelated mentions doesn't exceed the
  /// limit.
  bool addAndVerifyUnrelatedMentions(int count) {
    try {
      final entries = state.unrelatedMentions
          .map<Map<String, dynamic>>(
            (source) => jsonDecode(source) as Map<String, dynamic>,
          )
          .map(UnrelatedMentionsEntry.fromJson)
          .where((entries) => entries.expiresAt.isAfter(DateTime.now()))
          .toList()
        ..add(
          UnrelatedMentionsEntry(
            expiresAt: DateTime.now().add(const Duration(days: 1)),
            count: count,
          ),
        );

      final total = entries
          .map((entry) => entry.count)
          .reduce((value, count) => value + count);

      final entriesStringList =
          entries.map((entry) => jsonEncode(entry.toJson())).toList();

      if (total < 5) {
        _preferences.setStringList('unrelatedMentions', entriesStringList);
        state = state.copyWith(unrelatedMentions: entriesStringList);
        return true;
      } else {
        return false;
      }
    } catch (e, st) {
      logErrorHandler(e, st);

      _preferences.setStringList('unrelatedMentions', []);
      state = state.copyWith(unrelatedMentions: []);

      return true;
    }
  }

  final Preferences _preferences;
}

@freezed
class PostTweetPreferences with _$PostTweetPreferences {
  const factory PostTweetPreferences({
    required List<String> unrelatedMentions,
  }) = _PostTweetPreferences;
}

@freezed
class UnrelatedMentionsEntry with _$UnrelatedMentionsEntry {
  const factory UnrelatedMentionsEntry({
    required DateTime expiresAt,
    required int count,
  }) = _UnrelatedMentionsEntry;

  factory UnrelatedMentionsEntry.fromJson(Map<String, dynamic> json) =>
      _$UnrelatedMentionsEntryFromJson(json);
}
