import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/harpy.dart';

/// Shows a banner ad and builds the space that is occupied by the banner ad
/// in the free version of Harpy.
///
/// The banner ad act as an overlay that is anchored to the bottom of the
/// screen. The [HarpyBannerAd] prevents the app from occupying the space
/// below the banner.
class HarpyBannerAd extends StatefulWidget {
  HarpyBannerAd()
      : assert(Harpy.isFree),
        super(key: bannerKey);

  static GlobalKey<_HarpyBannerAdState> bannerKey = GlobalKey();

  @override
  _HarpyBannerAdState createState() => _HarpyBannerAdState();
}

class _HarpyBannerAdState extends State<HarpyBannerAd> {
  BannerAd bannerAd;

  double _height = 0;

  void showBanner() {
    if (Harpy.isFree) {
      bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: "ca-app-pub-8177884628224651/1410925457",
      )
        ..load()
        ..show()
        ..listener = _listener;
    }
  }

  void _listener(MobileAdEvent event) {
    if (event == MobileAdEvent.loaded) {
      setState(() {
        _height = bannerAd.size.height.toDouble();
      });
    } else if (event == MobileAdEvent.failedToLoad) {
      // reload ad in 30 seconds
      // a new banner needs to be instantiated, otherwise we can't reload the
      // banner ad

      Future.delayed(const Duration(seconds: 30)).then((_) => showBanner());
    }

    // other events such as failedToLoad or closed dont imply that no banner
    // is showing anymore, therefore we can't set the height to 0 again after
    // the banner loaded once
  }

  @override
  Widget build(BuildContext context) {
    final harpyTheme = HarpyTheme.of(context);

    return AnimatedContainer(
      height: _height,
      color: harpyTheme.backgroundColors.last,
      duration: const Duration(milliseconds: 300),
    );
  }
}
