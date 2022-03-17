import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/regex/twitter_regex.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class ComposeTweetActionRow extends StatelessWidget {
  const ComposeTweetActionRow({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ComposeBloc>();

    return Row(
      children: [
        HarpyButton.flat(
          padding: config.edgeInsets,
          icon: const Icon(CupertinoIcons.photo),
          iconSize: 20,
          onTap: () => bloc.add(const ComposeEvent.pickMedia()),
        ),
        smallHorizontalSpacer,
        HarpyButton.flat(
          padding: config.edgeInsets,
          icon: const Icon(CupertinoIcons.at),
          iconSize: 20,
          onTap: null,
        ),
        smallHorizontalSpacer,
        HarpyButton.flat(
          padding: config.edgeInsets,
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => controller.insertString('#'),
        ),
        const Spacer(),
        ComposeTweetMaxLenght(controller: controller),
        PostTweetButton(controller: controller),
      ],
    );
  }
}

class PostTweetButton extends StatefulWidget {
  const PostTweetButton({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  _PostTweetButtonState createState() => _PostTweetButtonState();
}

class _PostTweetButtonState extends State<PostTweetButton> {
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

  Future<void> _showDialog(ComposeBloc bloc) async {
    FocusScope.of(context).unfocus();

    final sentTweet = await showDialog<TweetData>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PostTweetDialog(
        composeBloc: bloc,
        controller: widget.controller,
      ),
    );

    if (sentTweet != null) {
      // since no navigation can happen while the dialog is showing, we can
      // that the context is still valid
      // ignore: use_build_context_synchronously
      context.read<HomeTimelineCubit>().addTweet(sentTweet);

      // ignore: use_build_context_synchronously
      Navigator.popUntil(
        context,
        (route) => route.settings.name == HomeScreen.route,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<ComposeBloc>();

    var canTweet =
        bloc.state.hasMedia || widget.controller.text.trim().isNotEmpty;

    if (mentionRegex.hasMatch(widget.controller.text.trim())) {
      canTweet = false;
    }

    return HarpyButton.flat(
      padding: config.edgeInsets,
      icon: const Icon(Icons.send),
      iconSize: 20,
      onTap: canTweet ? () => _showDialog(bloc) : null,
    );
  }
}
