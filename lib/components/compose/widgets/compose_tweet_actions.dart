import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class ComposeTweetActions extends ConsumerWidget {
  const ComposeTweetActions({
    required this.controller,
    required this.focusNode,
  });

  final ComposeTextController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(composeProvider.notifier);

    return Row(
      children: [
        HarpyButton.icon(
          icon: const Icon(CupertinoIcons.photo),
          onTap: notifier.pickMedia,
        ),
        smallHorizontalSpacer,
        HarpyButton.icon(
          icon: const Icon(CupertinoIcons.at),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.insertString('@');
            focusNode.requestFocus();
          },
        ),
        smallHorizontalSpacer,
        HarpyButton.icon(
          label: const Text('#'),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.insertString('#');
            focusNode.requestFocus();
          },
        ),
        const Spacer(),
        ComposeMaxLength(controller: controller),
        smallHorizontalSpacer,
        _PostTweetButton(controller: controller),
      ],
    );
  }
}

class _PostTweetButton extends StatefulWidget {
  const _PostTweetButton({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  _PostTweetButtonState createState() => _PostTweetButtonState();
}

class _PostTweetButtonState extends State<_PostTweetButton> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_listener);
  }

  void _listener() {
    setState(() {});
  }

  // Future<void> _showDialog(ComposeBloc bloc) async {
  //   FocusScope.of(context).unfocus();

  //   final sentTweet = await showDialog<TweetData>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => PostTweetDialog(
  //       composeBloc: bloc,
  //       controller: widget.controller,
  //     ),
  //   );

  //   if (sentTweet != null) {
  //     // since no navigation can happen while the dialog is showing, we can
  //     // that the context is still valid
  //     // ignore: use_build_context_synchronously
  //     context.read<HomeTimelineCubit>().addTweet(sentTweet);

  //     // ignore: use_build_context_synchronously
  //     Navigator.popUntil(
  //       context,
  //       (route) => route.settings.name == HomeScreen.route,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final config = context.watch<ConfigCubit>().state;

    // final bloc = context.watch<ComposeBloc>();

    // final canTweet =
    //     bloc.state.hasMedia || widget.controller.text.trim().isNotEmpty;

    // TODO:

    return HarpyButton.icon(
      icon: const Icon(Icons.send),
      // onTap: canTweet ? () => _showDialog(bloc) : null,
      onTap: () {},
    );
  }
}
