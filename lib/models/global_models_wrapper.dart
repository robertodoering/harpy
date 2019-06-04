import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:provider/provider.dart';

/// Wraps the app wide [Provider]s and holds the instances in its state.
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

    homeTimelineModel ??= HomeTimelineModel(
      tweetService: serviceProvider.data.tweetService,
      homeTimelineCache: serviceProvider.data.homeTimelineCache,
    );

    loginModel ??= LoginModel(
      homeTimelineModel: homeTimelineModel,
      userService: serviceProvider.data.userService,
      userCache: serviceProvider.data.userCache,
    );

    applicationModel ??= ApplicationModel(
      directoryService: serviceProvider.data.directoryService,
      userTimelineCache: serviceProvider.data.userTimelineCache,
      homeTimelineCache: serviceProvider.data.homeTimelineCache,
      twitterClient: serviceProvider.data.twitterClient,
      harpyPrefs: serviceProvider.data.harpyPrefs,
      connectivityService: serviceProvider.data.connectivityService,
      themeSettingsModel: ThemeSettingsModel.of(context),
      loginModel: loginModel,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationModel>(
          builder: (_) => applicationModel,
        ),
        ChangeNotifierProvider<LoginModel>(
          builder: (_) => loginModel,
        ),
        ChangeNotifierProvider<HomeTimelineModel>(
          builder: (_) => homeTimelineModel,
        ),
      ],
      child: widget.child,
    );
  }
}
