import 'package:flutter/material.dart';
import 'package:harpy/__old_components/screens/login/login_button.dart';
import 'package:harpy/__old_components/shared/harpy_title.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/theme.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: HarpyTheme.harpyColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: HarpyTitle(skipIntroAnimation: true),
            ),
          ),
          Expanded(
            child: ScopedModelDescendant<LoginModel>(
              builder: (context, _, model) {
                if (model.authorizing) {
                  return Container();
                } else {
                  return LoginButton(model.login);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
