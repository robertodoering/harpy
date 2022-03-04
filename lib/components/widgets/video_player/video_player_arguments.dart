import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_player_arguments.freezed.dart';

@freezed
class VideoPlayerArguments with _$VideoPlayerArguments {
  const factory VideoPlayerArguments({
    required BuiltMap<String, String> urls,
    required bool loop,
    @Default(false) bool isVideo,
  }) = _VideoPlayerArguments;
}
