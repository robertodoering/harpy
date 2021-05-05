import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

/// A dialog that uses the [PostTweetBloc] to post a tweet.
///
/// While posting the tweet is in progress, the dialog is not dismissible.
class PostTweetDialog extends StatelessWidget {
  const PostTweetDialog({
    required this.composeBloc,
    required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostTweetBloc>(
      create: (BuildContext context) => PostTweetBloc(
        controller!.text,
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
    required this.composeBloc,
    required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController? controller;

  Widget _buildStateMessage(ThemeData theme, PostTweetState state) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration ~/ 2,
      child: Column(
        children: <Widget>[
          Text(
            state.message!,
            key: Key(state.message!),
          ),
          if (state.hasAdditionalInfo) ...<Widget>[
            defaultSmallVerticalSpacer,
            Text(
              state.additionalInfo!,
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

    return WillPopPostTweetDialog(
      child: HarpyDialog(
        title: const Text('tweeting'),
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
            text: 'ok',
            onTap: state.inProgress
                ? null
                : () => app<HarpyNavigator>().state!.maybePop(),
          )
        ],
      ),
    );
  }
}

class WillPopPostTweetDialog extends StatelessWidget {
  const WillPopPostTweetDialog({
    required this.child,
  });

  final Widget child;

  Future<bool> _onWillPop(BuildContext context, PostTweetState state) async {
    if (!state.inProgress) {
      if (state is TweetSuccessfullyPosted) {
        Navigator.of(context).pop<TweetData>(state.tweet);
      } else {
        Navigator.of(context).pop<void>();
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final PostTweetBloc postTweetBloc = context.watch<PostTweetBloc>();
    final PostTweetState state = postTweetBloc.state;

    return WillPopScope(
      onWillPop: () => _onWillPop(context, state),
      child: child,
    );
  }
}
