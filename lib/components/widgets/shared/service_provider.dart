import 'package:flutter/material.dart';
import 'package:harpy/api/translate/translate_service.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/misc/directory_service.dart';

/// Builds the [ServiceProvider] and holds services in its state.
class ServiceContainer extends StatefulWidget {
  final Widget child;

  const ServiceContainer({
    @required this.child,
  });

  @override
  ServiceContainerState createState() => ServiceContainerState();
}

class ServiceContainerState extends State<ServiceContainer> {
  DirectoryService directoryService;
  TwitterClient twitterClient;
  HomeTimelineCache homeTimelineCache;
  UserTimelineCache userTimelineCache;
  TweetService tweetService;
  UserCache userCache;
  UserService userService;
  TranslationService translationService;

  @override
  void initState() {
    super.initState();

    directoryService = DirectoryService();
    twitterClient = TwitterClient();
    homeTimelineCache = HomeTimelineCache(directoryService: directoryService);
    userTimelineCache = UserTimelineCache(directoryService: directoryService);
    tweetService = TweetService(
      directoryService: directoryService,
      twitterClient: twitterClient,
      homeTimelineCache: homeTimelineCache,
      userTimelineCache: userTimelineCache,
    );
    userCache = UserCache(directoryService: directoryService);
    userService = UserService(
      twitterClient: twitterClient,
      userCache: userCache,
    );
    translationService = TranslationService();
  }

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: widget.child,
      data: this,
    );
  }
}

/// Holds the app wide services.
///
/// The [ServiceProvider] can be accessed throughout the app with
/// `ServiceProvider.of(context)`, often inside of build methods in widgets.
///
/// Example:
/// ```
/// final serviceProvider = ServiceProvider.of(context);
///
/// TweetService tweetService = serviceProvider.data.tweetService;
/// ```
class ServiceProvider extends InheritedWidget {
  const ServiceProvider({
    @required Widget child,
    this.data,
  }) : super(child: child);

  final ServiceContainerState data;

  static ServiceProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ServiceProvider)
        as ServiceProvider;
  }

  @override
  bool updateShouldNotify(ServiceProvider old) {
    // service provider shouldn't rebuild
    return false;
  }
}
