import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/logger_mixin.dart';
import 'package:harpy/core/service_locator.dart';

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
