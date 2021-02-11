import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/old_bloc/post_tweet/post_tweet_state.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// A dialog that uses the [PostTweetBloc] to post a tweet.
///
/// While posting the tweet is in progress, the dialog is not dismissible.
class PostTweetDialog extends StatelessWidget {
  const PostTweetDialog({
    @required this.controller,
  });

  final ComposeTextController controller;

  Future<bool> _onWillPop(
    ComposeBloc composeBloc,
    PostTweetBloc postTweetBloc,
  ) async {
    if (postTweetBloc.inProgress) {
      return false;
    } else {
      if (postTweetBloc.postingSuccessful) {
        // cleanup after successful post
        composeBloc.add(const ClearComposedTweet());
        controller.text = '';
      }

      return true;
    }
  }

  Widget _buildStateMessage(ThemeData theme, PostTweetState state) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration ~/ 2,
      child: Column(
        children: <Widget>[
          Text(
            state.message,
            key: Key(state.message),
          ),
          if (state.hasAdditionalInfo) ...<Widget>[
            defaultSmallVerticalSpacer,
            Text(
              state.additionalInfo,
              style: theme.textTheme.bodyText1,
            ),
          ],
        ],
      ),
    );
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
    final ThemeData theme = Theme.of(context);
    final ComposeBloc composeBloc = context.watch<ComposeBloc>();

    return BlocProvider<PostTweetBloc>(
      create: (BuildContext context) => PostTweetBloc(
        controller.text,
        composeBloc: composeBloc,
      ),
      child: BlocBuilder<PostTweetBloc, PostTweetState>(
        builder: (BuildContext context, PostTweetState state) {
          final PostTweetBloc postTweetBloc = PostTweetBloc.of(context);

          return WillPopScope(
            // prevent back button to close the dialog while in progress
            onWillPop: () => _onWillPop(composeBloc, postTweetBloc),
            child: HarpyDialog(
              title: const Text('Tweeting'),
              content: CustomAnimatedSize(
                child: Column(
                  children: <Widget>[
                    if (state.hasMessage) _buildStateMessage(theme, state),
                    if (postTweetBloc.inProgress) _buildLoading(postTweetBloc),
                  ],
                ),
              ),
              actions: <Widget>[
                DialogAction<void>(
                  text: 'Ok',
                  onTap: postTweetBloc.inProgress
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
