import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:harpy/misc/misc.dart';

const _path = 'assets/flare';

class FlareIcon extends StatelessWidget {
  const FlareIcon({
    required this.fileName,
    this.size = 18,
    this.sizeDifference = 0,
    this.offset = Offset.zero,
    this.animation,
    this.color,
  });

  /// An animated favorite icon.
  const FlareIcon.favorite({
    required String animation,
    double size = 18,
    Color? color,
  }) : this(
          fileName: '$_path/favorite.flr',
          size: size,
          sizeDifference: -0.5,
          animation: animation,
          color: color,
        );

  /// An animated shining star icon.
  const FlareIcon.shiningStar({
    double size = 18,
    Offset offset = Offset.zero,
  }) : this(
          fileName: '$_path/shining_star.flr',
          size: size,
          offset: offset,
          animation: 'shining',
        );

  /// The harpy logo.
  const FlareIcon.harpyLogo({
    double size = 18,
    bool animate = false,
    Offset offset = Offset.zero,
  }) : this(
          fileName: '$_path/harpy_logo.flr',
          size: size,
          sizeDifference: 14,
          offset: offset,
          animation: animate ? 'show' : null,
        );

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
  final String? animation;

  /// Overrides the icon color when set.
  final Color? color;

  double get _calculatedSize => size + sizeDifference;

  /// Loads the icons and adds them into the cache to make sure a widget
  /// using a [FlareIcon] doesn't appear blank for a few frames when it
  /// builds for the first time.
  static void cacheIcons(BuildContext context) {
    cachedActor(
      AssetFlare(
        bundle: DefaultAssetBundle.of(context),
        name: '$_path/shining_star.flr',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: SizedBox(
        width: _calculatedSize,
        height: _calculatedSize,
        // prevent building a flare actor in tests otherwise timer will be
        // pending after the widget tree gets disposed in tests which cause the
        // test to throw an exception
        child: isTest
            ? DecoratedBox(decoration: BoxDecoration(border: Border.all()))
            : FlareActor(
                fileName,
                animation: isTest ? null : animation,
                color: color,
              ),
      ),
    );
  }
}
