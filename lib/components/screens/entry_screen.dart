import 'package:flutter/material.dart';
import 'package:harpy/components/screens/home_screen.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';
import 'package:harpy/models/application_model.dart';

/// The 'splash screen' shown during the start of the app while the
/// [ApplicationModel] is initializing.
///
/// After initialization the [EntryScreen] will navigate to the [LoginScreen] or
/// skip to the [HomeScreen] if the user is already logged in.
class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // pre-cache flare icons
    FlareIcon.cacheIcons(context);

    return Container(color: Colors.black);
  }
}
