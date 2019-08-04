import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/components/widgets/shared/home_drawer.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/tweet/tweet_list.dart';
import 'package:harpy/models/home_timeline_model.dart';

/// The [HomeScreen] showing the [TweetList] after a user has logged in.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HarpyScaffold(
      title: "Harpy",
      drawer: HomeDrawer(),
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: const TweetList<HomeTimelineModel>(),
      ),
    );
  }

  /// Show a dialog if an attempt is made to exit the app by pressing the
  /// back button.
  Future<bool> _onWillPop(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      return showDialog(
        context: context,
        builder: (context) {
          return HarpyDialog(
            title: "Really exit?",
            actions: [
              DialogAction.discard,
              DialogAction.confirm,
            ],
          );
        },
      ).then((result) => result == true);
    } else {
      return Future.value(true);
    }
  }
}
