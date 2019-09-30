import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/components/widgets/shared/home_drawer.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/tweet/tweet_timeline.dart';
import 'package:harpy/components/widgets/user_search/user_search_action.dart';
import 'package:harpy/models/home_timeline_model.dart';

/// The [HomeScreen] showing the [TweetTimeline] after a user has logged in.
class HomeScreen extends StatelessWidget {
  /// Show a dialog if an attempt is made to exit the app by pressing the
  /// back button.
  Future<bool> _onWillPop(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      return showDialog(
        context: context,
        builder: (context) => HarpyDialog(
          title: "Really exit?",
          actions: [
            DialogAction.discard,
            DialogAction.confirm,
          ],
        ),
      ).then((result) => result == true);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Harpy",
      showIcon: true,
      drawer: HomeDrawer(),
      actions: <Widget>[
        UserSearchAction(),
      ],
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: const TweetTimeline<HomeTimelineModel>(),
      ),
    );
  }
}
