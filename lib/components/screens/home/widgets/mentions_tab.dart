import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class MentionsTab extends StatelessWidget {
  const MentionsTab({
    @required this.entry,
    this.cardColor,
  });

  final HomeTabEntry entry;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final MentionsTimelineBloc bloc = context.watch<MentionsTimelineBloc>();
    final MentionsTimelineState state = bloc.state;

    final Widget child = HarpyTab(
      icon: HomeTabEntryIcon(entry.icon),
      text: entry.hasName ? Text(entry.name) : null,
      cardColor: cardColor,
    );

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
