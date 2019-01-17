import 'package:flutter/material.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:scoped_model/scoped_model.dart';

/// Wraps the [ApplicationModel] and [LoginModel] at the top of the widget tree.
class GlobalScopedModels extends StatefulWidget {
  const GlobalScopedModels({
    @required this.child,
  });

  final Widget child;

  @override
  GlobalScopedModelsState createState() => GlobalScopedModelsState();
}

class GlobalScopedModelsState extends State<GlobalScopedModels> {
  ApplicationModel applicationModel;
  LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    applicationModel ??= ApplicationModel(
      directoryService: serviceProvider.data.directoryService,
    );

    loginModel ??= LoginModel(
      applicationModel: applicationModel,
      userCache: serviceProvider.data.userCache,
    );

    return ScopedModel<ApplicationModel>(
      model: applicationModel,
      child: ScopedModel<LoginModel>(
        model: loginModel,
        child: widget.child,
      ),
    );
  }
}
