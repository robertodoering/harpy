import 'package:flutter/material.dart';
import 'package:harpy/components/screens/login_screen.dart';
import 'package:harpy/theme.dart';

/// The entry screen of the app.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      // todo: if logged in draw different screen
      child: LoginScreen(),
    );
  }
}
