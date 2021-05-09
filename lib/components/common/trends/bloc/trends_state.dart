part of 'trends_bloc.dart';

abstract class TrendsState extends Equatable {
  const TrendsState();
}

extension TrendsExtension on TrendsState {
  bool get isLoading => this is RequestingTrends;

  bool get loadingFailed => this is FindTrendsFailure;

  bool get hasTrends =>
      this is FoundTrendsState && (this as FoundTrendsState).trends.isNotEmpty;

  List<Trend> get trends =>
      this is FoundTrendsState ? (this as FoundTrendsState).trends : <Trend>[];

  int get trendsCount =>
      this is FoundTrendsState ? (this as FoundTrendsState).trends.length : 0;

  List<Trend> get hashtags => this is FoundTrendsState
      ? (this as FoundTrendsState).hashtags
      : <Trend>[];

  TrendsLocationData? get location {
    if (this is RequestingTrends) {
      return (this as RequestingTrends).location;
    } else if (this is FoundTrendsState) {
      return (this as FoundTrendsState).location;
    } else if (this is FindTrendsFailure) {
      return (this as FindTrendsFailure).location;
    } else {
      return null;
    }
  }

  String get trendLocationName =>
      location != null ? 'trends in ${location!.name}' : 'trends';
}

class TrendsInitial extends TrendsState {
  const TrendsInitial();

  @override
  List<Object> get props => <Object>[];
}

class RequestingTrends extends TrendsState {
  const RequestingTrends({
    required this.location,
  });

  /// The location used to request trends with.
  final TrendsLocationData location;

  @override
  List<Object> get props => <Object>[
        location,
      ];
}

class FoundTrendsState extends TrendsState {
  FoundTrendsState({
    required this.woeid,
    required this.trends,
    required this.location,
  }) : hashtags = trends.where((trend) => trend.name!.startsWith('#')).toList();

  final int woeid;
  final List<Trend> trends;
  final List<Trend> hashtags;

  /// The location used to request trends with.
  final TrendsLocationData location;

  @override
  List<Object> get props => <Object>[
        woeid,
        trends,
        hashtags,
        location,
      ];
}

class FindTrendsFailure extends TrendsState {
  const FindTrendsFailure({
    required this.location,
  });

  /// The location used to request trends with.
  final TrendsLocationData location;

  @override
  List<Object> get props => <Object>[
        location,
      ];
}
