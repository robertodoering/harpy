import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class ComposeTweetActionRow extends StatelessWidget {
  const ComposeTweetActionRow(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final TextEditingController controller;

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
          onTap: () {},
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('@', style: TextStyle(fontSize: 20)),
          onTap: () => controller.text += '@',
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => controller.text += '#',
        ),
        const Spacer(),
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.send),
          iconSize: 20,
          onTap: () {},
        ),
      ],
    );
  }
}
