import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// The [GlobalProvider] is built above the root [MaterialApp] to provide
/// every descendant with globally available blocs & state.
class GlobalProvider extends StatelessWidget {
  const GlobalProvider({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SystemBrightnessObserver(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ConfigCubit()),
          BlocProvider(
            create: (context) => ThemeBloc(
              configCubit: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthenticationCubit(
              themeBloc: context.read(),
            ),
          ),
          BlocProvider(
            // can't be lazy since initialization starts upon bloc creation
            lazy: false,
            create: (context) => ApplicationCubit(
              systemBrightness: context.read(),
              themeBloc: context.read(),
              configCubit: context.read(),
              authenticationCubit: context.read(),
            ),
          ),
          BlocProvider(create: (_) => TimelineFilterCubit()..initialize()),
          BlocProvider(
            create: (context) => HomeTimelineCubit(
              timelineFilterCubit: context.read(),
            ),
          ),
          BlocProvider(create: (_) => MentionsTimelineCubit()),
          BlocProvider(create: (_) => DownloadPathCubit()),
        ],
        child: child,
      ),
    );
  }
}
