import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

/// The initial screen that is shown when opening the app.
///
/// After initialization, the [ApplicationCubit] will navigate to either the
/// [LoginScreen] or the [HomeScreen].
class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    // start caching flare icons
    FlareIcon.cacheIcons(context);

    // start initializing localized date format
    initializeDateFormatting(Localizations.localeOf(context).toString());

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
