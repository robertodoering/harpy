import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/trends/bloc/trends_event.dart';
import 'package:harpy/components/trends/bloc/trends_state.dart';
import 'package:harpy/core/service_locator.dart';

class TrendsBloc extends Bloc<TrendsEvent, TrendsState> {
  TrendsBloc() : super(InitialTrendsState());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  static TrendsBloc of(BuildContext context) => context.watch<TrendsBloc>();

  List<Trends> trends = <Trends>[];

  /// Whether trends have been found.
  bool get hasTrends =>
      trends?.isNotEmpty == true && trends.first.trends?.isNotEmpty == true;

  @override
  Stream<TrendsState> mapEventToState(
    TrendsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
