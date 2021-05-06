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

  List<Trend> get hashtags => this is FoundTrendsState
      ? (this as FoundTrendsState).hashtags
      : <Trend>[];
}

class TrendsInitial extends TrendsState {
  const TrendsInitial();

  @override
  List<Object> get props => <Object>[];
}

class RequestingTrends extends TrendsState {
  const RequestingTrends();

  @override
  List<Object> get props => <Object>[];
}

class FoundTrendsState extends TrendsState {
  FoundTrendsState({
    required this.woeid,
    required this.trends,
  }) : hashtags = trends.where((trend) => trend.name!.startsWith('#')).toList();

  final int woeid;
  final List<Trend> trends;
  final List<Trend> hashtags;

  @override
  List<Object> get props => <Object>[
        woeid,
        trends,
        hashtags,
      ];
}

class FindTrendsFailure extends TrendsState {
  const FindTrendsFailure();

  @override
  List<Object> get props => <Object>[];
}
