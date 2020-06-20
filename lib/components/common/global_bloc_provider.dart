import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';

/// The [GlobalBlocProvider] is built above the root [MaterialApp] to provide
/// every descendant with globally available blocs.
///
/// These blocs will only be created once.
class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        // authentication
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(),
        ),

        // application
        // can't be lazy since initialization starts upon bloc creation
        BlocProvider<ApplicationBloc>(
          lazy: false,
          create: (BuildContext context) => ApplicationBloc(
            authenticationBloc: AuthenticationBloc.of(context),
          ),
        ),
      ],
      child: child,
    );
  }
}
