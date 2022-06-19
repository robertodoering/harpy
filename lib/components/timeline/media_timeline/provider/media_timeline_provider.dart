import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/services/connectivity_service.dart';

final mediaTimelineProvider = Provider.autoDispose
    .family<BuiltList<MediaTimelineEntry>, BuiltList<TweetData>>(
  (ref, tweets) {
    final mediaPreferences = ref.watch(mediaPreferencesProvider);
    final connectivity = ref.watch(connectivityProvider);

    final entries = <MediaTimelineEntry>[];

    for (final tweet in tweets) {
      for (final media in tweet.media) {
        final url = media.appropriateUrl(mediaPreferences, connectivity);

        if (!entries.any(
          (entry) =>
              entry.media.appropriateUrl(mediaPreferences, connectivity) == url,
        )) {
          entries.add(MediaTimelineEntry(tweet: tweet, media: media));
        }
      }
    }

    return entries.toBuiltList();
  },
  cacheTime: const Duration(minutes: 5),
  name: 'MediaTimelineProvider',
);
