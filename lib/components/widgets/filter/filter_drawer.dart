import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({
    required this.title,
    required this.filterGroups,
    required this.onSearch,
    required this.onClear,
    this.showClear = true,
    this.showSearchButton = true,
    this.searchButtonText = 'search',
    this.searchButtonIcon = CupertinoIcons.search,
  });

  final String title;
  final List<Widget> filterGroups;
  final VoidCallback onClear;
  final VoidCallback onSearch;
  final bool showClear;
  final bool showSearchButton;
  final String searchButtonText;
  final IconData searchButtonIcon;

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: [
        horizontalSpacer,
        Expanded(
          child: Text(title, style: theme.textTheme.subtitle1),
        ),
        HarpyButton.flat(
          dense: true,
          icon: const Icon(CupertinoIcons.xmark),
          onTap: showClear ? onClear : null,
        ),
      ],
    );
  }

  Widget _buildSearchButton(ThemeData theme, EdgeInsets padding) {
    return AnimatedSize(
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        duration: kShortAnimationDuration,
        child: showSearchButton
            ? Padding(
                padding: padding,
                child: SizedBox(
                  width: double.infinity,
                  child: HarpyButton.raised(
                    icon: Icon(searchButtonIcon),
                    text: Text(searchButtonText),
                    backgroundColor: theme.cardColor,
                    dense: true,
                    onTap: () async {
                      await app<HarpyNavigator>().maybePop();
                      onSearch();
                    },
                  ),
                ),
              )
            : verticalSpacer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Drawer(
      child: HarpyBackground(
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: [
            // add status bar height to top padding and make it scrollable
            SizedBox(height: config.paddingValue + mediaQuery.padding.top),
            _buildTitleRow(theme),
            _buildSearchButton(theme, config.edgeInsets),
            for (Widget group in filterGroups) ...[
              group,
              if (group != filterGroups.last) verticalSpacer,
            ],
            _buildSearchButton(
              theme,
              config.edgeInsets.copyWith(bottom: 0),
            ),
            // add nav bar height to bottom padding and make it scrollable
            SizedBox(height: config.paddingValue + mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
