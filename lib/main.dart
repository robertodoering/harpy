import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
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

  // HarpyErrorHandler will run the app and handle uncaught errors
  HarpyErrorHandler(
    child: const GlobalProvider(
      child: Harpy(),
    ),
  );
}
