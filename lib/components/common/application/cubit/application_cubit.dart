import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:harpy/components/common/authentication/cubit/authentication_cubit.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/core.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ApplicationCubit extends Cubit<ApplicationState> with HarpyLogger {
  ApplicationCubit({
    required this.themeBloc,
    required this.authenticationCubit,
  }) : super(const ApplicationState()) {
    _initialize();
  }

  final ThemeBloc themeBloc;
  final AuthenticationCubit authenticationCubit;

  Future<void> _initialize() async {
    initLogger();

    // sets the visibility detector controller update interval to fire more
    // frequently
    // this is used by the VisibilityDetector for the ListCardAnimation
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 50,
    );

    // need the device info before we continue with updating the system ui
    await app<HarpyInfo>().initialize();

    // update the system ui to match the initial theme
    themeBloc.updateSystemUi(themeBloc.harpyTheme);

    await Future.wait([
      FlutterDisplayMode.setHighRefreshRate(),
      app<HarpyPreferences>().initialize(),
      app<ConnectivityService>().initialize(),
    ]);
  }
}

class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}
