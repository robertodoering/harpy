import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds a floating compose button when scrolling up if the
/// [GeneralPreferences.floatingComposeButton] option is enabled.
class FloatingComposeButton extends StatelessWidget {
  const FloatingComposeButton({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scrollDirection = ScrollDirection.of(context);
    final harpyTheme = context.watch<HarpyTheme>();
    final config = context.watch<ConfigCubit>().state;

    Widget? button;

    if (app<GeneralPreferences>().floatingComposeButton) {
      final route = ModalRoute.of(context)?.settings.name;
      final mediaQuery = MediaQuery.of(context);

      final show = scrollDirection != null && scrollDirection.up;

      final padding = config.bottomAppBar && route == HomeScreen.route
          ? HomeAppBar.height(context) + config.paddingValue
          : config.paddingValue + mediaQuery.padding.bottom;

      button = Align(
        alignment: Alignment.bottomRight,
        child: AnimatedOpacity(
          opacity: show ? 1 : 0,
          curve: Curves.easeInOut,
          duration: kShortAnimationDuration,
          child: AnimatedShiftedPosition(
            shift: show ? Offset.zero : const Offset(0, 1),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: padding,
                right: config.paddingValue,
              ),
              child: HarpyButton.raised(
                padding: config.edgeInsets,
                icon: Icon(
                  FeatherIcons.feather,
                  color: harpyTheme.foregroundColor,
                  size: 24,
                ),
                backgroundColor: harpyTheme.alternateCardColor,
                onTap: app<HarpyNavigator>().pushComposeScreen,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        child,
        if (button != null) button,
      ],
    );
  }
}
