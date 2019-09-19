import 'package:flutter/material.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/home_timeline_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/models/settings/theme_settings_model.dart';
import 'package:harpy/models/user_search_history_model.dart';
import 'package:provider/provider.dart';

/// Creates a [MultiProvider] with each global model.
///
/// These models are above the root [MaterialApp] and are only created once.
class GlobalModelsProvider extends StatelessWidget {
  const GlobalModelsProvider({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeTimelineModel>(
          builder: (_) => HomeTimelineModel(),
        ),
        ChangeNotifierProvider<LoginModel>(
          builder: (context) => LoginModel(
            homeTimelineModel: Provider.of<HomeTimelineModel>(
              context,
              listen: false,
            ),
          ),
        ),
        Provider<ApplicationModel>(
          builder: (context) => ApplicationModel(
            loginModel: Provider.of<LoginModel>(
              context,
              listen: false,
            ),
            themeSettingsModel: Provider.of<ThemeSettingsModel>(
              context,
              listen: false,
            ),
          ),
        ),
        Provider<UserSearchHistoryModel>(
          builder: (_) => UserSearchHistoryModel(),
        )
      ],
      child: child,
    );
  }
}
