import 'package:flutter/material.dart';
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
  DirectoryService directoryService;
  UserCache userCache;

  @override
  void initState() {
    super.initState();

    directoryService = DirectoryService();
    userCache = UserCache(directoryService: directoryService);
  }

  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      child: widget.child,
      directoryService: directoryService,
      userCache: userCache,
    );
  }
}

/// Holds the app wide services.
class ServiceProvider extends InheritedWidget {
  const ServiceProvider({
    @required Widget child,
    this.directoryService,
    this.userCache,
  }) : super(child: child);

  final DirectoryService directoryService;
  final UserCache userCache;

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
