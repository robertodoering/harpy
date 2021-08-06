import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

// todo: add actions to home timeline

//   List<Widget> _buildActions(
//     BuildContext context,
//     ThemeData theme,
//     TimelineFilterModel model,
//     HomeTimelineBloc bloc,
//   ) {
//     return [
//       HarpyButton.flat(
//         padding: const EdgeInsets.all(16),
//         icon: bloc.state.enableFilter &&
//                 bloc.state.timelineFilter != TimelineFilter.empty
//             ? Icon(Icons.filter_alt, color: theme.colorScheme.secondary)
//             : const Icon(Icons.filter_alt_outlined),
//         onTap:
//             bloc.state.enableFilter ? Scaffold.of(context).openEndDrawer : null,
//       ),
//       CustomPopupMenuButton<int>(
//         icon: const Icon(Icons.more_vert),
//         onSelected: (selection) {
//           if (selection == 0) {
//             ScrollDirection.of(context)!.reset();

//             bloc.add(const RefreshHomeTimeline(clearPrevious: true));
//           }
//         },
//         itemBuilder: (context) {
//           return <PopupMenuEntry<int>>[
//             const HarpyPopupMenuItem<int>(
//               value: 0,
//               text: Text('refresh'),
//             ),
//           ];
//         },
//       ),
//     ];
//   }

// todo: add support for building home app bar at the bottom

class HomeAppBar extends StatelessWidget {
  const HomeAppBar();

  static double height(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final config = context.read<ConfigCubit>().state;

    final systemPadding = config.bottomAppBar
        ? mediaQuery.padding.bottom
        : mediaQuery.padding.top;

    return HarpyTab.height(context) + systemPadding + 4;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final scrollDirection = ScrollDirection.of(context)!;
    final config = context.watch<ConfigCubit>().state;

    final topPadding = config.bottomAppBar ? 0.0 : mediaQuery.padding.top + 4;
    final bottomPadding =
        config.bottomAppBar ? mediaQuery.padding.bottom + 4 : 0.0;

    // since the sliver app bar does not work as intended with the nested
    // scroll view in the home tab view, we use an animated shifted position
    // widget and animate the app bar out of the view based on the scroll
    // position to manually hide / show the app bar
    return AnimatedShiftedPosition(
      shift: scrollDirection.direction == VerticalDirection.down
          ? const Offset(0, -1)
          : Offset.zero,
      child: Stack(
        children: [
          HomeTabBar(
            padding: EdgeInsets.only(
              top: topPadding,
              bottom: bottomPadding,
              left: HarpyTab.height(context) + config.paddingValue * 2,
              right: config.paddingValue,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: const _DrawerButton(),
          ),
        ],
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsetsOnly(left: true),
      child: HarpyButton.raised(
        backgroundColor: theme.colorScheme.primary.withOpacity(.9),
        padding: EdgeInsets.all(HarpyTab.tabPadding(context)),
        iconSize: HarpyTab.tabIconSize,
        icon: const RotatedBox(
          quarterTurns: 1,
          child: Icon(FeatherIcons.barChart2),
        ),
        onTap: Scaffold.of(context).openDrawer,
      ),
    );
  }
}
