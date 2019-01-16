import 'package:flutter/material.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:scoped_model/scoped_model.dart';

/// Wraps the [ApplicationModel] and [LoginModel] at the top of the widget tree.
class GlobalScopedModels extends StatelessWidget {
  const GlobalScopedModels({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    final applicationModel = ApplicationModel(
      directoryService: serviceProvider.directoryService,
    );

    return ScopedModel<ApplicationModel>(
      model: applicationModel,
      child: ScopedModel<LoginModel>(
        model: LoginModel(applicationModel: applicationModel),
        child: child,
      ),
    );
  }
}
