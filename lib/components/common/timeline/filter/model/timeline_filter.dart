import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timeline_filter.g.dart';

@JsonSerializable()
class TimelineFilter extends Equatable {
  const TimelineFilter({
    this.includesImages = false,
    this.includesGif = false,
    this.includesVideo = false,
    this.excludesHashtags = const <String>[],
    this.excludesPhrases = const <String>[],
    this.excludesReplies = false,
    this.excludesRetweets = false,
  });

  factory TimelineFilter.fromJson(Map<String, dynamic> json) =>
      _$TimelineFilterFromJson(json);

  factory TimelineFilter.fromJsonString(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return TimelineFilter.empty;
      } else {
        return TimelineFilter.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // unable to decode timeline filter
      return TimelineFilter.empty;
    }
  }

  final bool includesImages;
  final bool includesGif;
  final bool includesVideo;

  final List<String> excludesHashtags;
  final List<String> excludesPhrases;
  final bool excludesReplies;
  final bool excludesRetweets;

  static const TimelineFilter empty = TimelineFilter();

  @override
  List<Object> get props => <Object>[
        includesImages,
        includesGif,
        includesVideo,
        excludesHashtags,
        excludesPhrases,
        excludesReplies,
        excludesRetweets,
      ];

  Map<String, dynamic> toJson() => _$TimelineFilterToJson(this);

  TimelineFilter copyWith({
    bool? includesImages,
    bool? includesGif,
    bool? includesVideo,
    List<String>? excludesHashtags,
    List<String>? excludesPhrases,
    bool? excludesReplies,
    bool? excludesRetweets,
  }) {
    return TimelineFilter(
      includesImages: includesImages ?? this.includesImages,
      includesGif: includesGif ?? this.includesGif,
      includesVideo: includesVideo ?? this.includesVideo,
      excludesHashtags: excludesHashtags ?? this.excludesHashtags,
      excludesPhrases: excludesPhrases ?? this.excludesPhrases,
      excludesReplies: excludesReplies ?? this.excludesReplies,
      excludesRetweets: excludesRetweets ?? this.excludesRetweets,
    );
  }
}
