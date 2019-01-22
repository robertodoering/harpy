import 'package:flutter/material.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/service_provider.dart';
import 'package:scoped_model/scoped_model.dart';

/// Wraps the app wide [ScopedModel]s and holds the instances in its state.
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
  HomeTimelineModel homeTimelineModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    applicationModel ??= ApplicationModel(
      directoryService: serviceProvider.data.directoryService,
      tweetCache: serviceProvider.data.tweetCache,
      twitterClient: serviceProvider.data.twitterClient,
    );

    homeTimelineModel ??= HomeTimelineModel(
      tweetService: serviceProvider.data.tweetService,
      tweetCache: serviceProvider.data.tweetCache,
    );

    loginModel ??= LoginModel(
      applicationModel: applicationModel,
      homeTimelineModel: homeTimelineModel,
      userService: serviceProvider.data.userService,
      userCache: serviceProvider.data.userCache,
    );

    return ScopedModel<ApplicationModel>(
      model: applicationModel,
      child: ScopedModel<LoginModel>(
        model: loginModel,
        child: ScopedModel<HomeTimelineModel>(
          model: homeTimelineModel,
          child: widget.child,
        ),
      ),
    );
  }
}
