import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/common/flare_icons.dart';
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
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (BuildContext context, ApplicationState state) => MaterialApp(
        title: 'Harpy',
        theme: ApplicationBloc.of(context).harpyTheme.data,
        navigatorKey: app<HarpyNavigator>().key,
        onGenerateRoute: onGenerateRoute,
        home: SplashScreen(),
      ),
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
    // start caching flare icons
    FlareIcon.cacheIcons(context);

    return const Scaffold(
      body: Center(
        child: Text('splash screen'),
      ),
    );
  }
}
