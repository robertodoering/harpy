import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:equatable/equatable.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart';
import 'package:humanizer/humanizer.dart';

part 'post_tweet_event.dart';
part 'post_tweet_state.dart';

class PostTweetBloc extends Bloc<PostTweetEvent, PostTweetState> {
  PostTweetBloc(
    String text, {
    required this.composeBloc,
  }) : super(const PostTweetInitial()) {
    add(PostTweetEvent(text));
  }

  final ComposeBloc composeBloc;

  @override
  Stream<PostTweetState> mapEventToState(
    PostTweetEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
