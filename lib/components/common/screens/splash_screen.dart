import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/common/misc/harpy_background.dart';

/// The initial screen that is shown when opening the app.
///
/// After initializiation, the [ApplicationBloc] will navigate to either the
/// [LoginScreen] or the [HomeScreen].
class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    // start caching flare icons
    FlareIcon.cacheIcons(context);

    return const HarpyBackground(
      child: FractionallySizedBox(
        widthFactor: 0.66,
        child: FlareActor(
          'assets/flare/harpy_logo.flr',
          animation: 'show',
        ),
      ),
    );
  }
}
