part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  ThemeState({
    required this.lightThemeData,
    required this.darkThemeData,
    required this.customThemesData,
    required this.config,
  })  : lightHarpyTheme = HarpyTheme.fromData(
          data: lightThemeData,
          config: config,
        ),
        darkHarpyTheme = HarpyTheme.fromData(
          data: darkThemeData,
          config: config,
        );

  /// The selected light theme which will be used when the device is using the
  /// system light theme.
  final HarpyThemeData lightThemeData;

  /// The selected dark theme which will be used when the device is using the
  /// system dark theme.
  final HarpyThemeData darkThemeData;

  /// The list of custom themes for the currently authenticated user.
  final List<HarpyThemeData> customThemesData;

  final ConfigState config;

  // created during construction but independent from the immutability of the
  // state
  final HarpyTheme lightHarpyTheme;
  final HarpyTheme darkHarpyTheme;

  @override
  List<Object?> get props => [
        lightThemeData,
        darkThemeData,
        customThemesData,
        config,
      ];

  ThemeState copyWith({
    HarpyThemeData? lightThemeData,
    HarpyThemeData? darkThemeData,
    List<HarpyThemeData>? customThemesData,
    ConfigState? config,
  }) {
    return ThemeState(
      lightThemeData: lightThemeData ?? this.lightThemeData,
      darkThemeData: darkThemeData ?? this.darkThemeData,
      customThemesData: customThemesData ?? this.customThemesData,
      config: config ?? this.config,
    );
  }
}
