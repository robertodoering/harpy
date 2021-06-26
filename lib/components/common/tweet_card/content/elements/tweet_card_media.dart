import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class TweetCardMedia extends StatelessWidget {
  const TweetCardMedia();

  @override
  Widget build(BuildContext context) {
    final tweet = context.select<TweetBloc, TweetData>((bloc) => bloc.tweet);

    return TweetMedia(tweet);
  }
}
