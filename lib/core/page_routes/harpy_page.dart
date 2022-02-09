import 'package:flutter/widgets.dart';
import 'package:harpy/core/core.dart';

/// The page route type that determines the transition of the [HarpyPage].
enum PageRouteType {
  harpy,
  fade,
}

class HarpyPage<T> extends Page<T> {
  const HarpyPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.pageRouteType = PageRouteType.harpy,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
          key: key,
          name: name,
          arguments: arguments,
          restorationId: restorationId,
        );

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  /// Determines which page route is used.
  final PageRouteType pageRouteType;

  @override
  Route<T> createRoute(BuildContext context) {
    switch (pageRouteType) {
      case PageRouteType.harpy:
        return HarpyPageRoute(
          settings: this,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          builder: (_) => child,
        );
      case PageRouteType.fade:
        return FadePageRoute(
          settings: this,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          builder: (_) => child,
        );
    }
  }
}
