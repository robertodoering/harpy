import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetCardMedia extends StatelessWidget {
  const TweetCardMedia();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TweetBloc>();
    final tweet = bloc.state.tweet;

    return TweetMedia(tweet);
  }
}
