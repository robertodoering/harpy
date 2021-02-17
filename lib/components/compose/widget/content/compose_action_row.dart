import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/compose/widget/post_tweet/post_tweet_dialog.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/widgets/home_screen.dart';

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

  void _unfocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  Future<void> _showDialog(ComposeBloc bloc) async {
    _unfocus();

    final bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PostTweetDialog(
        composeBloc: bloc,
        controller: widget.controller,
      ),
    ).then((bool value) => value == true);

    if (result) {
      context
          .read<HomeTimelineBloc>()
          .add(const RefreshHomeTimeline(clearPrevious: true));

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
