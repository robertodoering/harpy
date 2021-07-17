import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/settings/config/bloc/config_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:provider/provider.dart';

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
          BlocProvider(create: (_) => ConfigBloc()),
          BlocProvider(
            create: (context) => ThemeBloc(
              configBloc: context.read<ConfigBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(
              themeBloc: context.read<ThemeBloc>(),
            ),
          ),
          BlocProvider(
            // can't be lazy since initialization starts upon bloc creation
            lazy: false,
            create: (context) => ApplicationBloc(
              authenticationBloc: context.read<AuthenticationBloc>(),
              themeBloc: context.read<ThemeBloc>(),
            ),
          ),
          BlocProvider(create: (_) => HomeTimelineBloc()),
          BlocProvider(create: (_) => MentionsTimelineBloc()),
        ],
        child: child,
      ),
    );
  }
}
