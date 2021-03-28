import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class MentionsTab extends StatelessWidget {
  const MentionsTab();

  @override
  Widget build(BuildContext context) {
    final MentionsTimelineBloc bloc = context.watch<MentionsTimelineBloc>();
    final MentionsTimelineState state = bloc.state;

    const Widget child = HarpyTab(icon: Text('@'));

    if (state.hasNewMentions) {
      return const Bubbled(
        bubble: Bubble(),
        bubbleOffset: Offset(2, -2),
        child: child,
      );
    } else {
      return child;
    }
  }
}
