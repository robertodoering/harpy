import 'package:dart_twitter_api/api/tweets/timeline_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_event.dart';
import 'package:harpy/components/timeline/common/bloc/timeline_state.dart';
import 'package:harpy/core/api/tweet_data.dart';
import 'package:harpy/core/service_locator.dart';

abstract class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final TimelineService timelineService = app<TwitterApi>().timelineService;

  /// The [tweets] for this timeline.
  List<TweetData> tweets = <TweetData>[];

  @override
  TimelineState get initialState => UninitializedState();

  @override
  Stream<TimelineState> mapEventToState(
    TimelineEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
