import 'package:flutter/material.dart';
import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:harpy/models/application_model.dart';
import 'package:harpy/models/login_model.dart';
import 'package:harpy/ui/screens/entry_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(ServiceProvider(
    child: GlobalScopedModels(
      child: MaterialApp(
        title: "Harpy",
        theme: ThemeData.dark(),
        home: EntryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  ));
}

class GlobalScopedModels extends StatelessWidget {
  const GlobalScopedModels({
    @required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    return ScopedModel<ApplicationModel>(
      model: ApplicationModel(
        directoryService: serviceProvider.directoryService,
      ),
      child: ScopedModel<LoginModel>(
        model: LoginModel(),
        child: child,
      ),
    );
  }
}

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
