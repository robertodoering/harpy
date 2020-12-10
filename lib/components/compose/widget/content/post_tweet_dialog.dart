import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

/// A non-dismissible dialog that uses the [PostTweetBloc] to post a tweet.
class PostTweetDialog extends StatelessWidget {
  const PostTweetDialog({
    @required this.text,
    @required this.composeBloc,
  });

  final String text;
  final ComposeBloc composeBloc;

  Widget _buildStateMessage(PostTweetState state) {
    return Text(state.message);
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostTweetBloc>(
      create: (BuildContext context) => PostTweetBloc(
        text,
        composeBloc: composeBloc,
      ),
      child: BlocBuilder<PostTweetBloc, PostTweetState>(
        builder: (BuildContext context, PostTweetState state) {
          final PostTweetBloc bloc = PostTweetBloc.of(context);

          return HarpyDialog(
            title: const Text('Tweeting'),
            content: Column(
              children: <Widget>[
                if (state.hasMessage) _buildStateMessage(state),
                if (bloc.inProgress) ...<Widget>[
                  defaultVerticalSpacer,
                  _buildLoading(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
