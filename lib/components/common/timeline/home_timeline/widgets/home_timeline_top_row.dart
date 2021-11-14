import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Built as the begin sliver for the home timeline.
class HomeTimelineTopRow extends StatelessWidget {
  const HomeTimelineTopRow();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Padding(
        padding: config.edgeInsetsOnly(
          top: true,
          left: true,
          right: true,
        ),
        child: Row(
          children: const [
            _RefreshButton(),
            Spacer(),
            _ComposeButton(),
            horizontalSpacer,
            _FilterButton(),
          ],
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<HomeTimelineCubit>();

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: const Icon(CupertinoIcons.refresh),
      onTap: () => cubit.load(clearPrevious: true),
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: const Icon(FeatherIcons.feather),
      onTap: () => app<HarpyNavigator>().pushComposeScreen(),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<HomeTimelineCubit>();

    return HarpyButton.raised(
      padding: config.edgeInsets,
      elevation: 0,
      backgroundColor: theme.cardTheme.color,
      icon: cubit.filter != TimelineFilter.empty
          ? Icon(Icons.filter_alt, color: theme.colorScheme.primary)
          : const Icon(Icons.filter_alt_outlined),
      onTap: Scaffold.of(context).openEndDrawer,
    );
  }
}
