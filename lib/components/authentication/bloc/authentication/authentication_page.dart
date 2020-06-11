import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication/index.dart';

class AuthenticationPage extends StatefulWidget {
  static const String routeName = '/authentication';

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _authenticationBloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: AuthenticationScreen(authenticationBloc: _authenticationBloc),
    );
  }
}
