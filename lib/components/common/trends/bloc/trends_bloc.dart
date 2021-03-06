import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

part 'trends_event.dart';
part 'trends_state.dart';

class TrendsBloc extends Bloc<TrendsEvent, TrendsState> {
  TrendsBloc() : super(const TrendsInitial());

  final trendsService = app<TwitterApi>().trendsService;

  final trendsPreferences = app<TrendsPreferences>();

  @override
  Stream<TrendsState> mapEventToState(
    TrendsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
