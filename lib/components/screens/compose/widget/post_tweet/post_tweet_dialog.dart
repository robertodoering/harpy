import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// A dialog that uses the [PostTweetCubit] to post a tweet.
///
/// While posting the tweet is in progress, the dialog is not dismissible.
class PostTweetDialog extends StatelessWidget {
  const PostTweetDialog({
    required this.composeBloc,
    required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostTweetCubit(
        composeBloc: composeBloc,
      )..post(controller.text),
      child: _Content(
        composeBloc: composeBloc,
        controller: controller,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.composeBloc,
    required this.controller,
  });

  final ComposeBloc composeBloc;
  final ComposeTextController? controller;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PostTweetCubit>();
    final state = cubit.state;

    return _WillPopDialog(
      child: HarpyDialog(
        title: const Text('tweeting'),
        content: AnimatedSize(
          duration: kShortAnimationDuration,
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              if (state.message != null) const _StateMessage(),
              if (state.inProgress) const _ProgressIndicator(),
            ],
          ),
        ),
        actions: [
          DialogAction<void>(
            text: 'ok',
            // need to use `maybePop` to trigger the `WillPopScope`
            onTap: state.inProgress ? null : Navigator.of(context).maybePop,
          ),
        ],
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.watch<PostTweetCubit>();
    final state = cubit.state;

    return AnimatedSwitcher(
      duration: kShortAnimationDuration ~/ 2,
      child: Column(
        children: [
          Text(
            state.message!,
            key: Key(state.message!),
          ),
          if (state.additionalInfo != null) ...[
            smallVerticalSpacer,
            Text(
              state.additionalInfo!,
              style: theme.textTheme.bodyText1,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return Column(
      children: [
        SizedBox(height: config.paddingValue * 2),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _WillPopDialog extends StatelessWidget {
  const _WillPopDialog({
    required this.child,
  });

  final Widget child;

  Future<bool> _onWillPop(BuildContext context, PostTweetState state) async {
    if (!state.inProgress) {
      Navigator.of(context).pop(state.tweet);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PostTweetCubit>();
    final state = cubit.state;

    return WillPopScope(
      onWillPop: () => _onWillPop(context, state),
      child: child,
    );
  }
}
