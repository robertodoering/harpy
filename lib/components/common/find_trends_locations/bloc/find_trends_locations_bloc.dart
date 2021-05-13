import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:location/location.dart' as location;

part 'find_trends_locations_event.dart';
part 'find_trends_locations_state.dart';

/// Handles finding trends locations that are available close to the provided
/// coordinates.
class FindTrendsLocationsBloc
    extends Bloc<FindTrendsLocationsEvent, FindTrendsLocationsState> {
  FindTrendsLocationsBloc() : super(const FindTrendsLocationsInitial());

  final TrendsService trendsService = app<TwitterApi>().trendsService;

  /// Validator for a text field that verifies the [value] is a valid
  /// latitude value.
  ///
  /// (0 to 90 deg)
  static String? latitudeValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      return _verifyRange(
        double.tryParse(value),
        low: 0,
        high: 90,
        errorMessage: 'invalid latitude',
      );
    } else {
      return null;
    }
  }

  /// Validator for a text field that verifies the [value] is a valid
  /// longitude value.
  ///
  /// (-180 to 180 deg)
  static String? longitudeValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      return _verifyRange(
        double.tryParse(value),
        low: -180,
        high: 180,
        errorMessage: 'invalid longitude',
      );
    } else {
      return null;
    }
  }

  static String? _verifyRange(
    double? value, {
    required double low,
    required double high,
    required String errorMessage,
  }) {
    if (value != null) {
      if (value < low || value > high) {
        // out of range
        return errorMessage;
      } else {
        // valid
        return null;
      }
    } else {
      // invalid value
      return errorMessage;
    }
  }

  @override
  Stream<FindTrendsLocationsState> mapEventToState(
    FindTrendsLocationsEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
