import 'package:flutter/material.dart';
import 'package:harpy/models/application_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// The screen shown during the start of the app.
///
/// A 'splash screen' with the title will be drawn during initialization.
///
/// After initialization the [EntryScreen] will navigate to the [LoginScreen] or
/// skip to the [HomeScreen] if the user is already logged in
class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScopedModelDescendant<ApplicationModel>(
          builder: (context, _, model) {
            if (model.initialized) {
              // navigate to home or login after initialization
              return _buildNavigator(model);
            } else {
              // draw splash screen
              return _buildSplashScreen();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Text('initializing ...');
  }

  Widget _buildNavigator(ApplicationModel model) {
    return Navigator(
      initialRoute: model.loggedIn ? 'login' : 'home',
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == 'login') {
          return MaterialPageRoute(
              builder: (context) => Center(child: Text('home screen')));
        } else {
          return MaterialPageRoute(
              builder: (context) => Center(child: Text('login screen')));
        }
      },
    );
  }
}
