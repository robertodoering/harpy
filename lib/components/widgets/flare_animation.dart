import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _assetsToWarmup = [
  AssetFlare(bundle: rootBundle, name: 'assets/flare/harpy_logo.flr'),
  AssetFlare(bundle: rootBundle, name: 'assets/flare/harpy_title.flr'),
  AssetFlare(bundle: rootBundle, name: 'assets/flare/shining_star.flr'),
];

/// Ensure all Flare assets used by this app are cached and ready to be
/// displayed as quickly as possible.
Future<void> warmupFlare() async {
  for (final asset in _assetsToWarmup) {
    await cachedActor(asset);
  }
}

class FlareAnimation extends StatelessWidget {
  const FlareAnimation.harpyTitle({
    // ignore: non_directional
    this.alignment = Alignment.center,
    this.animation,
    this.color,
  }) : name = 'harpy_title';

  const FlareAnimation.harpyLogo({
    // ignore: non_directional
    this.alignment = Alignment.center,
    this.animation,
    this.color,
  }) : name = 'harpy_logo';

  final String name;
  final Alignment alignment;
  final String? animation;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      'assets/flare/$name.flr',
      animation: animation,
      alignment: alignment,
      color: color,
    );
  }
}

class FlareIcon extends StatelessWidget {
  const FlareIcon.harpyLogo({
    this.iconSize,
  })  : name = 'harpy_logo',
        animation = null,
        sizeDelta = 8;

  const FlareIcon.shiningStar({
    this.iconSize,
  })  : name = 'shining_star',
        animation = 'shining',
        sizeDelta = 6;

  final double? iconSize;

  final String name;
  final String? animation;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? IconTheme.of(context).size;
    assert(size != null);

    return SizedBox(
      width: size,
      height: size,
      child: OverflowBox(
        maxWidth: size! + sizeDelta,
        maxHeight: size + sizeDelta,
        child: UnconstrainedBox(
          child: SizedBox(
            width: size + sizeDelta,
            height: size + sizeDelta,
            child: FlareActor(
              'assets/flare/$name.flr',
              animation: animation,
            ),
          ),
        ),
      ),
    );
  }
}
