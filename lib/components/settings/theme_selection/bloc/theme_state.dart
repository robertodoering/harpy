part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  ThemeState({
    required this.lightThemeData,
    required this.darkThemeData,
    required this.customThemes,
    required this.config,
  })  : lightHarpyTheme = HarpyTheme.fromData(
          data: lightThemeData,
          config: config,
        ),
        darkHarpyTheme = HarpyTheme.fromData(
          data: darkThemeData,
          config: config,
        );

  final HarpyThemeData lightThemeData;
  final HarpyThemeData darkThemeData;
  final List<HarpyThemeData> customThemes;
  final ConfigState config;

  final HarpyTheme lightHarpyTheme;
  final HarpyTheme darkHarpyTheme;

  @override
  List<Object?> get props => [
        lightThemeData,
        darkThemeData,
        customThemes,
        config,
      ];

  ThemeState copyWith({
    HarpyThemeData? lightThemeData,
    HarpyThemeData? darkThemeData,
    List<HarpyThemeData>? customThemes,
    ConfigState? config,
  }) {
    return ThemeState(
      lightThemeData: lightThemeData ?? this.lightThemeData,
      darkThemeData: darkThemeData ?? this.darkThemeData,
      customThemes: customThemes ?? this.customThemes,
      config: config ?? this.config,
    );
  }
}
