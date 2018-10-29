import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/core/app_configuration.dart';
import 'package:harpy/stores/login_store.dart';

void main() async {
  await AppConfiguration().init();

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    title: "Flutter Led",
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>
    with StoreWatcherMixin<MainScreen> {
  LoginStore store;
  bool loggedIn = false;

  MainScreenState() {
    store = listenToStore(loginStoreToken);
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    loggedIn = await store.loggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("login"),
          onPressed: loggedIn ? null : LoginStore.twitterLogin,
        ),
      ),
    );
  }
}
