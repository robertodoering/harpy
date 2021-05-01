import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ComposeTweetActionRow extends StatelessWidget {
  const ComposeTweetActionRow({
    @required this.controller,
  });

  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    final ComposeBloc bloc = context.watch<ComposeBloc>();

    return Row(
      children: <Widget>[
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(CupertinoIcons.photo),
          iconSize: 20,
          onTap: () => bloc.add(const PickTweetMediaEvent()),
        ),
        defaultSmallHorizontalSpacer,
        // todo: implement adding new photos
        // HarpyButton.flat(
        //   padding: DefaultEdgeInsets.all(),
        //   icon: const Icon(Icons.add_a_photo),
        //   iconSize: 20,
        //   onTap: null,
        // ),
        // defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(CupertinoIcons.at),
          iconSize: 20,
          onTap: () => controller.insertString('@'),
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => controller.insertString('#'),
        ),
        const Spacer(),
        PostTweetButton(controller: controller),
      ],
    );
  }
}

class PostTweetButton extends StatefulWidget {
  const PostTweetButton({
    @required this.controller,
    Key key,
  }) : super(key: key);

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
    removeFocus(context);

    final TweetData sentTweet = await showDialog<TweetData>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PostTweetDialog(
        composeBloc: bloc,
        controller: widget.controller,
      ),
    );

    if (sentTweet != null) {
      context.read<HomeTimelineBloc>().add(AddToHomeTimeline(tweet: sentTweet));

      Navigator.popUntil(
        context,
        (Route<dynamic> route) => route.settings.name == HomeScreen.route,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ComposeBloc bloc = context.watch<ComposeBloc>();

    final bool canTweet =
        bloc.state.hasMedia || widget.controller.text.trim().isNotEmpty;

    return HarpyButton.flat(
      padding: DefaultEdgeInsets.all(),
      icon: const Icon(Icons.send),
      iconSize: 20,
      onTap: canTweet ? () => _showDialog(bloc) : null,
    );
  }
}
