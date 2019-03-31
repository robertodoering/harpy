import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:scoped_model/scoped_model.dart';

/// Wraps the app wide [ScopedModel]s and holds the instances in its state.
class GlobalModelsWrapper extends StatefulWidget {
  const GlobalModelsWrapper({
    @required this.child,
  });

  final Widget child;

  @override
  GlobalModelsWrapperState createState() => GlobalModelsWrapperState();
}

class GlobalModelsWrapperState extends State<GlobalModelsWrapper> {
  ApplicationModel applicationModel;
  LoginModel loginModel;
  HomeTimelineModel homeTimelineModel;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    applicationModel ??= ApplicationModel(
      directoryService: serviceProvider.data.directoryService,
      userTimelineCache: serviceProvider.data.userTimelineCache,
      homeTimelineCache: serviceProvider.data.homeTimelineCache,
      twitterClient: serviceProvider.data.twitterClient,
      harpyPrefs: serviceProvider.data.harpyPrefs,
      connectivityService: serviceProvider.data.connectivityService,
      themeSettingsModel: ThemeSettingsModel.of(context),
    );

    homeTimelineModel ??= HomeTimelineModel(
      tweetService: serviceProvider.data.tweetService,
      homeTimelineCache: serviceProvider.data.homeTimelineCache,
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
