import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/api/tweets/data/tweet.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/media_upload_service.dart';
import 'package:harpy/core/api/twitter/media_video_converter.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/logger_mixin.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:http/http.dart';
import 'package:humanize/humanize.dart';
import 'package:meta/meta.dart';

part 'post_tweet_event.dart';
part 'post_tweet_state.dart';

class PostTweetBloc extends Bloc<PostTweetEvent, PostTweetState> {
  PostTweetBloc(
    String text, {
    @required this.composeBloc,
  }) : super(const PostTweetInitial()) {
    add(PostTweetEvent(text));
  }

  final ComposeBloc composeBloc;

  final TweetService tweetService = app<TwitterApi>().tweetService;
  final MediaUploadService mediaUploadService = app<MediaUploadService>();

  @override
  Stream<PostTweetState> mapEventToState(
    PostTweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
