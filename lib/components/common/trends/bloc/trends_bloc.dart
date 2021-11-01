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
  TrendsBloc() : super(const TrendsInitial()) {
    on<TrendsEvent>((event, emit) => event.handle(this, emit));
  }

  final trendsPreferences = app<TrendsPreferences>();
}
