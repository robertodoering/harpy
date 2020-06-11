import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/application/bloc/application/application_bloc.dart';

class GlobalStateProvider extends StatelessWidget {
  const GlobalStateProvider({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        BlocProvider<ApplicationBloc>(
          lazy: false,
          create: (BuildContext context) => ApplicationBloc(),
        ),
      ],
      child: child,
    );
  }
}
