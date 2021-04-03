import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class MentionsTab extends StatelessWidget {
  const MentionsTab({
    this.cardColor,
  });

  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final MentionsTimelineBloc bloc = context.watch<MentionsTimelineBloc>();
    final MentionsTimelineState state = bloc.state;

    final Widget child = HarpyTab(icon: const Text('@'), cardColor: cardColor);

    if (state.hasNewMentions) {
      return Bubbled(
        bubble: const Bubble(),
        bubbleOffset: const Offset(2, -2),
        child: child,
      );
    } else {
      return child;
    }
  }
}
