import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/tweet_data.dart';
import 'package:harpy/components/common/tweet/bloc/tweet_bloc.dart';

class PreviewTweetBloc extends TweetBloc {
  PreviewTweetBloc(TweetData tweet) : super(tweet);

  @override
  void onCardTap(TweetData tweet) {
    // do nothing
  }

  @override
  void onRepliesTap(TweetData tweet) {
    // do nothing
  }

  @override
  void onViewMoreActions(BuildContext context, TweetData tweet) {
    // do nothing
  }

  @override
  void onRetweet() {
    // do nothing
  }

  @override
  void onUnretweet() {
    // do nothing
  }

  @override
  void onComposeQuote() {
    // do nothing
  }

  @override
  void onFavorite() {
    // do nothing
  }

  @override
  void onUnfavorite() {
    // do nothing
  }

  @override
  void onTranslate(Locale locale) {
    // do nothing
  }
}
