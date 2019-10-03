import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/dialogs.dart';
import 'package:harpy/components/widgets/shared/flare_buttons.dart';

class FlareIcon extends StatelessWidget {
  const FlareIcon({
    @required this.fileName,
    this.size = 18,
    this.sizeDifference = 0,
    this.offset = Offset.zero,
    this.animation,
    this.color,
  });

  /// An animated favorite icon used by [FavoriteButton].
  const FlareIcon.favorite({
    @required String animation,
    double size = 18,
    Color color,
  }) : this(
          fileName: "$_path/favorite.flr",
          size: size,
          sizeDifference: -0.5,
          animation: animation,
          color: color,
        );

  /// An animated shining star icon used by [ProFeatureDialog].
  const FlareIcon.shiningStar({
    double size = 18,
    Offset offset = Offset.zero,
  }) : this(
          fileName: "$_path/shining_star.flr",
          size: size,
          offset: offset,
          animation: "shining",
        );

  const FlareIcon.harpyLogo({
    double size = 18,
    bool animate = false,
    Offset offset = Offset.zero,
  }) : this(
          fileName: "$_path/harpy_logo.flr",
          size: size,
          sizeDifference: 14,
          offset: offset,
          animation: animate ? "show" : null,
        );

  static const String _path = "assets/flare";

  /// The path of the flare asset file.
  final String fileName;

  /// The size is used with the [sizeDifference] to calculate the size of the
  /// container.
  final double size;

  /// The size difference is used to have the flare icon with a given size
  /// appear the same as material icons with the same size.
  final double sizeDifference;

  /// Used to transform the icon using a translation.
  final Offset offset;

  /// The name of the animation that should play.
  final String animation;

  /// If set the color will overwrite the icon color.
  final Color color;

  double get _calculatedSize => size + sizeDifference;

  /// Loads the icons and adds them into the cache to make sure a widget
  /// using a [FlareIcon] doesn't appear blank for a few frames when it
  /// builds for the first time.
  static void cacheIcons(BuildContext context) {
    cachedActor(DefaultAssetBundle.of(context), "$_path/favorite.flr");
    cachedActor(DefaultAssetBundle.of(context), "$_path/shining_star.flr");
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: SizedBox(
        width: _calculatedSize,
        height: _calculatedSize,
        child: FlareActor(
          fileName,
          animation: animation,
          color: color,
        ),
      ),
    );
  }
}
