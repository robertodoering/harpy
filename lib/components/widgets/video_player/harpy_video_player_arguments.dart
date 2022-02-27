import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'harpy_video_player_arguments.freezed.dart';

@freezed
class HarpyVideoPlayerArguments with _$HarpyVideoPlayerArguments {
  const factory HarpyVideoPlayerArguments({
    required BuiltMap<String, String> urls,
    required bool autoplay,
    required bool loop,
  }) = _HarpyVideoPlayerArguments;
}
