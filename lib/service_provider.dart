import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/services/tweet_service.dart';
import 'package:harpy/core/cache/user_cache.dart';
import 'package:harpy/core/filesystem/directory_service.dart';

/// Builds the [ServiceProvider] at the top of the widget tree.
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

  TweetService get tweetService => _tweetService;
  TweetService _tweetService;

  UserCache get userCache => _userCache;
  UserCache _userCache;

  @override
  void initState() {
    super.initState();

    _directoryService = DirectoryService();
    _tweetService = TweetService();
    _userCache = UserCache(directoryService: _directoryService);
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
