import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'trends_event.dart';
part 'trends_state.dart';

class TrendsBloc extends Bloc<TrendsEvent, TrendsState> {
  TrendsBloc() : super(const TrendsInitial());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  @override
  Stream<TrendsState> mapEventToState(
    TrendsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
