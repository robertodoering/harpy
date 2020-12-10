import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

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

  Widget _buildLoading(PostTweetBloc bloc) {
    return Column(
      children: <Widget>[
        SizedBox(height: defaultPaddingValue * 2),
        const Center(child: CircularProgressIndicator()),
      ],
    );
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

          return WillPopScope(
            // prevent back button to close the dialog while in progress
            onWillPop: () async => !bloc.inProgress,
            child: HarpyDialog(
              title: const Text('Tweeting'),
              content: CustomAnimatedSize(
                child: Column(
                  children: <Widget>[
                    if (state.hasMessage) _buildStateMessage(state),
                    if (bloc.inProgress) _buildLoading(bloc),
                  ],
                ),
              ),
              actions: <Widget>[
                DialogAction<void>(
                  text: 'Ok',
                  onTap: bloc.inProgress
                      ? null
                      : () => app<HarpyNavigator>().state.maybePop(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
