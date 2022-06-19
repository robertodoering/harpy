import 'package:flutter/cupertino.dart';

class HomeTabEntryIcon extends StatelessWidget {
  const HomeTabEntryIcon(
    this.iconName, {
    this.color,
  });

  /// The name that matches the icon data in [iconNameMap].
  ///
  /// If the [iconName] is one character long, the text is used as the icon
  /// instead.
  final String? iconName;

  final Color? color;

  /// Maps the name of an icon to its [IconData].
  static const iconNameMap = <String, IconData>{
    // default
    'home': CupertinoIcons.home,
    'photo': CupertinoIcons.photo,
    'at': CupertinoIcons.at,
    'search': CupertinoIcons.search,
    // suit
    'suit_club': CupertinoIcons.suit_club,
    'suit_diamond': CupertinoIcons.suit_diamond,
    'suit_heart': CupertinoIcons.suit_heart,
    'suit_spade': CupertinoIcons.suit_spade,
    // weather
    'cloud': CupertinoIcons.cloud,
    'drop': CupertinoIcons.drop,
    'hurricane': CupertinoIcons.hurricane,
    'moon': CupertinoIcons.moon,
    'snow': CupertinoIcons.snow,
    'sun_max': CupertinoIcons.sun_max,
    'umbrella': CupertinoIcons.umbrella,
    'wind': CupertinoIcons.wind,
    // misc
    'compass': CupertinoIcons.compass,
    'exclamationmark': CupertinoIcons.exclamationmark,
    'flag': CupertinoIcons.flag,
    'flame': CupertinoIcons.flame,
    'gift': CupertinoIcons.gift,
    'hammer': CupertinoIcons.hammer,
    'hand_thumbsup': CupertinoIcons.hand_thumbsup,
    'headphones': CupertinoIcons.headphones,
    'hourglass': CupertinoIcons.hourglass,
    'lightbulb': CupertinoIcons.lightbulb,
    'mic': CupertinoIcons.mic,
    'music_note': CupertinoIcons.music_note,
    'music_note_2': CupertinoIcons.music_note_2,
    'question': CupertinoIcons.question,
    'scissors': CupertinoIcons.scissors,
    'sparkles': CupertinoIcons.sparkles,
    'waveform': CupertinoIcons.waveform,
    'zzz': CupertinoIcons.zzz,
    // money
    'money_dollar': CupertinoIcons.money_dollar,
    'money_euro': CupertinoIcons.money_euro,
    'money_pound': CupertinoIcons.money_pound,
    'money_rubl': CupertinoIcons.money_rubl,
    'money_yen': CupertinoIcons.money_yen,
    // math
    'add': CupertinoIcons.add,
    'divide': CupertinoIcons.divide,
    'minus': CupertinoIcons.minus,
    // shapes
    'circle': CupertinoIcons.circle,
    'hexagon': CupertinoIcons.hexagon,
    'square': CupertinoIcons.square,
    'triangle': CupertinoIcons.triangle,
  };

  @override
  Widget build(BuildContext context) {
    final size = IconTheme.of(context).size;

    if (iconName?.length == 1) {
      return Container(
        width: size,
        height: size,
        alignment: AlignmentDirectional.center,
        child: Text(
          iconName!,
          style: TextStyle(
            fontSize: size,
            height: 1,
            color: color,
          ),
          overflow: TextOverflow.clip,
        ),
      );
    } else {
      return Icon(
        iconNameMap[iconName] ?? CupertinoIcons.circle,
        size: size,
        color: color,
      );
    }
  }
}
