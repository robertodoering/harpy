import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/api/twitter/services/user_service.dart';
import 'package:harpy/api/twitter/twitter_client.dart';
import 'package:harpy/core/cache/home_timeline_cache.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/cache/user_timeline_cache.dart';
import 'package:harpy/core/filesystem/directory_service.dart';

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
  DirectoryService get directoryService => _directoryService;
  DirectoryService _directoryService;

  TwitterClient get twitterClient => _twitterClient;
  TwitterClient _twitterClient;

  HomeTimelineCache get homeTimelineCache => _homeTimelineCache;
  HomeTimelineCache _homeTimelineCache;

  UserTimelineCache get userTimelineCache => _userTimelineCache;
  UserTimelineCache _userTimelineCache;

  TweetService get tweetService => _tweetService;
  TweetService _tweetService;

  UserCache get userCache => _userCache;
  UserCache _userCache;

  UserService get userService => _userService;
  UserService _userService;

  @override
  void initState() {
    super.initState();

    _directoryService = DirectoryService();
    _twitterClient = TwitterClient();
    _homeTimelineCache = HomeTimelineCache(directoryService: _directoryService);
    _userTimelineCache = UserTimelineCache(directoryService: _directoryService);
    _tweetService = TweetService(
      directoryService: _directoryService,
      twitterClient: _twitterClient,
      homeTimelineCache: _homeTimelineCache,
      userTimelineCache: _userTimelineCache,
    );
    _userCache = UserCache(directoryService: _directoryService);
    _userService = UserService(
      twitterClient: _twitterClient,
      userCache: _userCache,
    );
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
