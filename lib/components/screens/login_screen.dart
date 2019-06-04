import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/harpy_title.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:provider/provider.dart';

/// Shows a [HarpyTitle] and a [LoginButton] to allow a user to login.
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final applicationModel = ApplicationModel.of(context);

    return Material(
      color: HarpyTheme.harpyColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Center(
              child: HarpyTitle(),
            ),
          ),
          Expanded(
            child: Consumer<LoginModel>(
              builder: (context, model, _) {
                if (model.authorizing || applicationModel.loggedIn) {
                  return Container();
                } else {
                  return LoginButton(onPressed: model.login);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
