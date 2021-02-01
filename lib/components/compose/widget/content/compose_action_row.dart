import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_event.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/compose/widget/content/post_tweet_dialog.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class ComposeTweetActionRow extends StatelessWidget {
  const ComposeTweetActionRow(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(FeatherIcons.image),
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
          text: const Text('@', style: TextStyle(fontSize: 20)),
          onTap: () => controller.insertString('@'),
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => controller.insertString('#'),
        ),
        const Spacer(),
        PostTweetButton(controller: controller, bloc: bloc),
      ],
    );
  }
}

class PostTweetButton extends StatefulWidget {
  const PostTweetButton({
    Key key,
    @required this.controller,
    @required this.bloc,
  }) : super(key: key);

  final ComposeTextController controller;
  final ComposeBloc bloc;

  @override
  _PostTweetButtonState createState() => _PostTweetButtonState();
}

class _PostTweetButtonState extends State<PostTweetButton> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final bool canTweet =
        widget.bloc.hasMedia || widget.controller.text.trim().isNotEmpty;

    return HarpyButton.flat(
      padding: DefaultEdgeInsets.all(),
      icon: const Icon(Icons.send),
      iconSize: 20,
      onTap: canTweet
          ? () => showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => PostTweetDialog(
                  controller: widget.controller,
                  composeBloc: widget.bloc,
                ),
              )
          : null,
    );
  }
}
