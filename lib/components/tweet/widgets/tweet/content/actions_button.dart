import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/view_more_action_button.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';

class TweetActionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TweetBloc bloc = TweetBloc.of(context);

    return ViewMoreActionButton(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: const Text('Open externally'),
          onTap: () {},
        ),
        // todo: if tweet has text
        ListTile(
          leading: const Icon(Icons.copy),
          title: const Text('Copy text'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share Tweet'),
          onTap: () {},
        ),
      ],
    );
  }
}
