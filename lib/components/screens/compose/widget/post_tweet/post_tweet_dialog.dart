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
      create: (_) => PostTweetBloc(
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
        children: [
          Text(
            state.message!,
            key: Key(state.message!),
          ),
          if (state.hasAdditionalInfo) ...[
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

  Widget _buildLoading(Config config, PostTweetBloc bloc) {
    return Column(
      children: [
        SizedBox(height: config.paddingValue * 2),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final postTweetBloc = context.watch<PostTweetBloc>();
    final state = postTweetBloc.state;

    return WillPopPostTweetDialog(
      child: HarpyDialog(
        title: const Text('tweeting'),
        content: AnimatedSize(
          duration: kShortAnimationDuration,
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              if (state.hasMessage) _buildStateMessage(theme, state),
              if (state.inProgress) _buildLoading(config, postTweetBloc),
            ],
          ),
        ),
        actions: [
          DialogAction<void>(
            text: 'ok',
            onTap: state.inProgress ? null : app<HarpyNavigator>().maybePop,
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
    final postTweetBloc = context.watch<PostTweetBloc>();
    final state = postTweetBloc.state;

    return WillPopScope(
      onWillPop: () => _onWillPop(context, state),
      child: child,
    );
  }
}
