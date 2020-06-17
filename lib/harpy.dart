import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication/authentication_event.dart';
import 'package:harpy/components/common/global_bloc_provider.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// Runs the app with the given [flavor].
///
/// To app can be build with the 'free' or 'pro' flavor by running
/// `flutter build --flavor free -t lib/main_free.dart` or
/// `flutter build --flavor pro -t lib/main_pro.dart`.
void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

  setupServices();

  runApp(
    GlobalBlocProvider(
      child: Harpy(),
    ),
  );
}

class Harpy extends StatelessWidget {
  static Flavor flavor;

  static bool get isFree => flavor == Flavor.free;
  static bool get isPro => flavor == Flavor.pro;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harpy',
      navigatorKey: app<HarpyNavigator>().key,
      onGenerateRoute: onGenerateRoute,
      home: SplashScreen(),
    );
  }
}

enum Flavor {
  free,
  pro,
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('splash screen'),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  static const String route = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            AuthenticationBloc.of(context).add(const LogoutEvent());
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
