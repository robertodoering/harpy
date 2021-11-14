import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'compose_bloc.freezed.dart';
part 'compose_event.dart';

class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  ComposeBloc({
    this.inReplyToStatus,
    this.quotedTweet,
  }) : super(ComposeState(media: BuiltList())) {
    on<ComposeEvent>((event, emit) => event.handle(this, emit));
  }

  final TweetData? inReplyToStatus;
  final TweetData? quotedTweet;
}

@freezed
class ComposeState with _$ComposeState {
  const factory ComposeState({
    required BuiltList<PlatformFile> media,
    MediaType? type,
  }) = _State;
}

extension ComposeStateExtension on ComposeState {
  bool get hasMedia => media.isNotEmpty;
  bool get hasImages => type == MediaType.image;
  bool get hasGif => type == MediaType.gif;
  bool get hasVideo => type == MediaType.video;
}
