import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/components/trends/bloc/trends_bloc.dart';
import 'package:harpy/components/trends/bloc/trends_state.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:logging/logging.dart';

@immutable
abstract class TrendsEvent {
  const TrendsEvent();

  Stream<TrendsState> applyAsync({
    TrendsState currentState,
    TrendsBloc bloc,
  });
}

class FindTrendsEvent extends TrendsEvent {
  const FindTrendsEvent({
    @required this.woeid,
  });

  const FindTrendsEvent.global() : this(woeid: 1);

  static final Logger _log = Logger('FindTrendsEvent');

  /// The Yahoo! Where On Earth ID of the location to return trending
  /// information for. Global information is available by using 1 as the
  /// `WOEID`.
  final int woeid;

  @override
  Stream<TrendsState> applyAsync({
    TrendsState currentState,
    TrendsBloc bloc,
  }) async* {
    _log.fine('finding trends for woeid: $woeid');

    yield RequestingTrendsState();

    final List<Trends> trends = await bloc.trendsService
        .place(id: woeid)
        .catchError(silentErrorHandler);

    if (trends != null) {
      bloc.trends = trends;
      _log.fine('found ${trends.length}');
    }

    yield UpdatedTrendsState();
  }
}
