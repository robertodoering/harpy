import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/post_tweet/post_tweet_bloc.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// A dialog that uses the [PostTweetBloc] to post a tweet.
///
/// While posting the tweet is in progress, the dialog is not dismissible.
class PostTweetDialog extends StatelessWidget {
  const PostTweetDialog({
    @required this.composeBloc,
    @required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostTweetBloc>(
      create: (BuildContext context) => PostTweetBloc(
        controller.text,
        composeBloc: composeBloc,
      ),
      child: PostTweetDialogContent(
        composeBloc: composeBloc,
        controller: controller,
      ),
    );
  }
}

class PostTweetDialogContent extends StatelessWidget {
  const PostTweetDialogContent({
    @required this.composeBloc,
    @required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController controller;

  Future<bool> _onWillPop(PostTweetState state) async {
    if (state.inProgress) {
      return false;
    } else {
      if (state.postingSuccessful) {
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
    final PostTweetBloc postTweetBloc = context.watch<PostTweetBloc>();
    final PostTweetState state = postTweetBloc.state;

    return WillPopScope(
      // prevent back button to close the dialog while in progress
      onWillPop: () => _onWillPop(state),
      child: HarpyDialog(
        title: const Text('Tweeting'),
        content: CustomAnimatedSize(
          child: Column(
            children: <Widget>[
              if (state.hasMessage) _buildStateMessage(theme, state),
              if (state.inProgress) _buildLoading(postTweetBloc),
            ],
          ),
        ),
        actions: <Widget>[
          DialogAction<void>(
            text: 'Ok',
            onTap: state.inProgress
                ? null
                : () => app<HarpyNavigator>().state.maybePop(),
          )
        ],
      ),
    );
  }
}
