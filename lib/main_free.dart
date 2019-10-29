import 'package:firebase_admob/firebase_admob.dart';
import 'package:harpy/harpy.dart';

/// Runs Harpy with [Flavor.free].
///
/// To build the app with the 'free' flavor run
/// `flutter build --flavor free -t lib/main_free.dart`
void main() {
  // todo: should reload when not having a connection in the beginning
  bannerAd
    ..load()
    ..show();

  runHarpy(Flavor.free);
}

final bannerAd = BannerAd(
  size: AdSize.fullBanner,
  adUnitId: BannerAd.testAdUnitId,
);
