import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'harpy_theme_data.g.dart';

@immutable
@JsonSerializable()
class HarpyThemeData extends Equatable {
  const HarpyThemeData({
    required this.name,
    required this.backgroundColors,
    required this.primaryColor,
    this.secondaryColor,
    this.cardColor,
    this.statusBarColor,
    this.navBarColor,
  });

  // HarpyThemeData.fromHarpyTheme(HarpyTheme harpyTheme)
  //     : name = harpyTheme.name,
  //       backgroundColors =
  //           harpyTheme.backgroundColors.map((color) => color.value).toList(),
  //       accentColor = harpyTheme.accentColor.value;

  // HarpyThemeData.from(HarpyThemeData other)
  //     : name = other.name,
  //       backgroundColors = List<int>.of(other.backgroundColors),
  //       accentColor = other.accentColor;

  factory HarpyThemeData.fromJson(Map<String, dynamic> json) =>
      _$HarpyThemeDataFromJson(json);

  final String name;
  final List<int> backgroundColors;
  final int primaryColor;
  final int? secondaryColor;
  final int? cardColor;
  final int? statusBarColor;
  final int? navBarColor;

  @override
  List<Object?> get props => [
        name,
        backgroundColors,
        primaryColor,
        secondaryColor,
        cardColor,
        statusBarColor,
        navBarColor,
      ];

  Map<String, dynamic> toJson() => _$HarpyThemeDataToJson(this);

  HarpyThemeData copyWith({
    String? name,
    List<int>? backgroundColors,
    int? primaryColor,
    int? secondaryColor,
    int? cardColor,
    int? statusBarColor,
    int? navBarColor,
  }) {
    return HarpyThemeData(
      name: name ?? this.name,
      backgroundColors: backgroundColors ?? this.backgroundColors,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      cardColor: cardColor ?? this.cardColor,
      statusBarColor: statusBarColor ?? this.statusBarColor,
      navBarColor: navBarColor ?? this.navBarColor,
    );
  }
}
