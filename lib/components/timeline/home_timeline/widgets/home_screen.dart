import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/common/dialogs/changelog_dialog.dart';
import 'package:harpy/components/common/dialogs/harpy_exit_dialog.dart';
import 'package:harpy/components/common/list/scroll_direction_listener.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/widget/compose_screen.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_bloc.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

import 'content/home_drawer.dart';
import 'home_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    this.autoLogin = false,
  });

  /// Whether the user got automatically logged in when opening the app
  /// (previous session got restored).
  final bool autoLogin;

  static const String route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    if (widget.autoLogin == true) {
      ChangelogDialog.maybeShow(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // force a rebuild when the home screen shows again
    setState(() {});
  }

  void _onScrollDirectionChanged(VerticalDirection direction) {
    final bool show = direction != VerticalDirection.down;

    if (_showFab != show) {
      setState(() {
        _showFab = show;
      });
    }
  }

  Widget _buildFloatingActionButton() {
    if (_showFab) {
      return FloatingActionButton(
        onPressed: () => app<HarpyNavigator>().pushNamed(ComposeScreen.route),
        child: const Icon(FeatherIcons.feather, size: 28),
      );
    } else {
      return null;
    }
  }

  Future<bool> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const HarpyExitDialog(),
    ).then((bool pop) => pop == true);
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // If the current pop request will close the application
    if (!Navigator.of(context).canPop()) {
      return _showExitDialog(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      onScrollDirectionChanged: _onScrollDirectionChanged,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: HarpyScaffold(
          drawer: const HomeDrawer(),
          floatingActionButton: _buildFloatingActionButton(),
          body: BlocProvider<HomeTimelineBloc>(
            create: (_) => HomeTimelineBloc(),
            child: const HomeTimeline(),
          ),
        ),
      ),
    );
  }
}
