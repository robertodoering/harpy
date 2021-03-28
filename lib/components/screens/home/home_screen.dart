import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

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

    context.read<HomeTimelineBloc>().add(const RequestInitialHomeTimeline());
    context.read<MentionsTimelineBloc>().add(const RequestMentionsTimeline());
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
        onPressed: () => app<HarpyNavigator>().pushComposeScreen(),
        child: const Icon(FeatherIcons.feather, size: 28),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopHarpy(
      child: ScrollDirectionListener(
        onScrollDirectionChanged: _onScrollDirectionChanged,
        child: ChangeNotifierProvider<TimelineFilterModel>(
          create: (_) => TimelineFilterModel.home(),
          child: BlocProvider<TrendsBloc>(
            create: (_) => TrendsBloc()..add(const FindTrendsEvent.global()),
            child: HarpyScaffold(
              drawer: const HomeDrawer(),
              endDrawer: const HomeTimelineFilterDrawer(),
              endDrawerEnableOpenDragGesture: false,
              floatingActionButton: _buildFloatingActionButton(),
              body: const HomeTabView(),
            ),
          ),
        ),
      ),
    );
  }
}
