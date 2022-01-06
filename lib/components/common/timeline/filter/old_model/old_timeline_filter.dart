import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'old_timeline_filter.g.dart';

@JsonSerializable()
class OldTimelineFilter extends Equatable {
  const OldTimelineFilter({
    this.includesImages = false,
    this.includesGif = false,
    this.includesVideo = false,
    this.excludesHashtags = const <String>[],
    this.excludesPhrases = const <String>[],
    this.excludesReplies = false,
    this.excludesRetweets = false,
  });

  factory OldTimelineFilter.fromJson(Map<String, dynamic> json) =>
      _$OldTimelineFilterFromJson(json);

  factory OldTimelineFilter.fromJsonString(String jsonString) {
    try {
      if (jsonString.isEmpty) {
        return OldTimelineFilter.empty;
      } else {
        return OldTimelineFilter.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      // unable to decode timeline filter
      return OldTimelineFilter.empty;
    }
  }

  final bool includesImages;
  final bool includesGif;
  final bool includesVideo;

  final List<String> excludesHashtags;
  final List<String> excludesPhrases;
  final bool excludesReplies;
  final bool excludesRetweets;

  static const OldTimelineFilter empty = OldTimelineFilter();

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

  Map<String, dynamic> toJson() => _$OldTimelineFilterToJson(this);

  OldTimelineFilter copyWith({
    bool? includesImages,
    bool? includesGif,
    bool? includesVideo,
    List<String>? excludesHashtags,
    List<String>? excludesPhrases,
    bool? excludesReplies,
    bool? excludesRetweets,
  }) {
    return OldTimelineFilter(
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
