import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/application/bloc/application_bloc.dart';
import 'package:harpy/components/application/bloc/application_state.dart';
import 'package:harpy/components/common/flare_icons.dart';
import 'package:harpy/components/common/global_bloc_provider.dart';
import 'package:harpy/core/harpy_error_handler.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';

/// The [Flavor] the app is built in.
enum Flavor {
  free,
  pro,
}

/// Runs the app with the given [flavor].
///
/// To app can be build with the 'free' or 'pro' flavor by running
/// `flutter build --flavor free -t lib/main_free.dart` or
/// `flutter build --flavor pro -t lib/main_pro.dart`.
void runHarpy(Flavor flavor) {
  Harpy.flavor = flavor;

  // sets up the global service locator
  setupServices();

  // HarpyErrorHandler will run the app and handle uncaught errors
  HarpyErrorHandler(
    child: GlobalBlocProvider(
      child: Harpy(),
    ),
  );
}

/// Builds the root [MaterialApp].
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
