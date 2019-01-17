import 'package:flutter/material.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/widgets/screens/login_screen.dart';
import 'package:harpy/widgets/shared/scaffolds.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginModel = LoginModel.of(context);

    return HarpyScaffold(
      appBar: "Harpy",
      body: Center(
        child: RaisedButton(onPressed: () async {
          await loginModel.logout();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        }),
      ),
    );
  }
}
