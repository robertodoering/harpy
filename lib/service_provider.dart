import 'package:flutter/material.dart';
import 'package:harpy/core/filesystem/directory_service.dart';

/// Holds the services at the top of the widget tree.
class ServiceProvider extends InheritedWidget {
  ServiceProvider({
    @required Widget child,
  })  : directoryService = DirectoryService(),
        super(child: child);

  final DirectoryService directoryService;

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
