import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/settings/config/bloc/config_bloc.dart';

/// The [GlobalBlocProvider] is built above the root [MaterialApp] to provide
/// every descendant with globally available blocs.
///
/// These blocs will only be created once.
class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        BlocProvider<ConfigBloc>(create: (_) => ConfigBloc()),
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            themeBloc: context.read<ThemeBloc>(),
          ),
        ),
        BlocProvider<ApplicationBloc>(
          // can't be lazy since initialization starts upon bloc creation
          lazy: false,
          create: (context) => ApplicationBloc(
            authenticationBloc: context.read<AuthenticationBloc>(),
            themeBloc: context.read<ThemeBloc>(),
          ),
        ),
        BlocProvider<HomeTimelineBloc>(create: (_) => HomeTimelineBloc()),
        BlocProvider<MentionsTimelineBloc>(
          create: (_) => MentionsTimelineBloc(),
        ),
      ],
      child: child,
    );
  }
}
