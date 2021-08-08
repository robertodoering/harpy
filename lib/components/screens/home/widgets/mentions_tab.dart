import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class MentionsTab extends StatelessWidget {
  const MentionsTab({
    required this.entry,
  });

  final HomeTabEntry entry;

  @override
  Widget build(BuildContext context) {
    final harpyTheme = context.watch<HarpyTheme>();

    final bloc = context.watch<MentionsTimelineBloc>();
    final state = bloc.state;

    final Widget child = HarpyTab(
      icon: HomeTabEntryIcon(entry.icon),
      text: entry.hasName ? Text(entry.name!) : null,
      cardColor: harpyTheme.alternateCardColor,
    );

    if (state.hasNewMentions) {
      return Bubbled(
        bubble: const Bubble(),
        child: child,
      );
    } else {
      return child;
    }
  }
}
