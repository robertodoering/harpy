import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:harpy/components/common/misc/global_bloc_provider.dart';
import 'package:harpy/core/harpy_error_handler.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';

/// The app can be built with the 'free' or 'pro' flavor by running
/// `flutter run --flavor free --dart-define=flavor=free` or
/// `flutter run --flavor pro --dart-define=flavor=pro` respectively.
///
/// Additionally a twitter api key is required for authentication and can be
/// specified using
/// `--dart-define=twitter_consumer_key=your_consumer_key` and
/// `--dart-define=twitter_consumer_secret=your_consumer_secret`.
void main() {
  // sets up the global service locator
  setupServices();

  // enable resampling to improve scrolling on devices where the input
  // frequency does not match the display frequency
  // this will be set to true by default in future flutter releases
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;

  // HarpyErrorHandler will run the app and handle uncaught errors
  HarpyErrorHandler(
    child: GlobalBlocProvider(
      child: Harpy(),
    ),
  );
}
