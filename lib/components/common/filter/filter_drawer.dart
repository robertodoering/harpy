import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({
    @required this.title,
    @required this.filterGroups,
    @required this.onSearch,
    @required this.onClear,
    this.showClear = true,
    this.showSearchButton = true,
    this.searchButtonText = 'search',
  });

  final String title;
  final List<Widget> filterGroups;
  final VoidCallback onClear;
  final VoidCallback onSearch;
  final bool showClear;
  final bool showSearchButton;
  final String searchButtonText;

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: <Widget>[
        defaultHorizontalSpacer,
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
    return CustomAnimatedSize(
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
                    icon: const Icon(CupertinoIcons.search),
                    text: Text(searchButtonText),
                    backgroundColor: theme.cardColor,
                    dense: true,
                    onTap: () {
                      onSearch();
                      app<HarpyNavigator>().state.maybePop();
                    },
                  ),
                ),
              )
            : defaultVerticalSpacer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Drawer(
      child: HarpyBackground(
        child: ListView(
          primary: false,
          padding: EdgeInsets.zero,
          children: <Widget>[
            // add status bar height to top padding and make it scrollable
            SizedBox(height: defaultPaddingValue + mediaQuery.padding.top),
            _buildTitleRow(theme),
            _buildSearchButton(theme, DefaultEdgeInsets.all()),
            for (Widget group in filterGroups) ...<Widget>[
              group,
              if (group != filterGroups.last) defaultVerticalSpacer,
            ],
            _buildSearchButton(
                theme, DefaultEdgeInsets.all().copyWith(bottom: 0)),
            // add nav bar height to bottom padding and make it scrollable
            SizedBox(height: defaultPaddingValue + mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}
