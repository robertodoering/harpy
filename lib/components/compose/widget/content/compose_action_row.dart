import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_event.dart';
import 'package:harpy/components/compose/widget/compose_text_cotroller.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class ComposeTweetActionRow extends StatelessWidget {
  const ComposeTweetActionRow(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final ComposeTextController controller;

  void _insertCharacter(String character) {
    if (controller.selection.baseOffset == controller.text.length &&
        !controller.text.endsWith(' ')) {
      character = ' $character';
    }

    controller.insertString(character);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.image),
          iconSize: 20,
          onTap: () {
            bloc.add(const PickTweetMediaEvent());
          },
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.add_a_photo),
          iconSize: 20,
          onTap: null,
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('@', style: TextStyle(fontSize: 20)),
          // todo: also focus text field
          onTap: () => _insertCharacter('@'),
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => _insertCharacter('#'),
        ),
        const Spacer(),
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.send),
          iconSize: 20,
          onTap: null,
        ),
      ],
    );
  }
}
