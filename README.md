<p align="center">
  <img max-height="172" src="media/harpy_title.png"/>
</p>

<p align="center">
a feature rich Twitter experience built with <a href="https://flutter.dev/">Flutter</a>
</p>

<p align="center">
  <a href="https://play.google.com/apps/testing/com.robertodoering.harpy.free">
    <img alt="Get it on Google Play"
         src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
         width="200"/>
  </a>
</p>

<br>

<p align="center">
  <a href="/LICENSE"><img src="https://img.shields.io/github/license/robertodoering/harpy?color=8B00FD"/></a>
  <a href="https://github.com/robertodoering/harpy/releases"><img src="https://img.shields.io/github/v/release/robertodoering/harpy?color=BC0492"/></a>
  <a href="https://play.google.com/store/apps/details?id=com.robertodoering.harpy.free"><img src="https://img.shields.io/endpoint?color=DE0747&logo=google-play&logoColor=BC0492&url=https%3A%2F%2Fplayshields.herokuapp.com%2Fplay%3Fi%3Dcom.robertodoering.harpy.free%26l%3Dinstalls%26m%3D%24installs"/></a>
  <a href="https://github.com/robertodoering/harpy/commits/master"><img src="https://img.shields.io/github/commits-since/robertodoering/harpy/latest?color=F2091C"/></a>
  <a href="https://github.com/robertodoering/harpy/commits/master"><img src="https://img.shields.io/github/commit-activity/m/robertodoering/harpy?color=FD0A04"/></a>
</p>
<p align="center">
  <a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true"/>
  </a>
</p>

<p align="center">
Harpy is currently still in development. See the <a href="https://github.com/robertodoering/harpy/projects/1">project</a> for more
information about the progress.
</p>

<br>

<p align="center">
  <img src="media/login_screen.gif"/>
  <img src="media/setup_screen.gif"/>
</p>

<details>
  <summary>More images</summary>
  
  | Home | User profile | Theme selection |
  | :---: | :---: | :---: |
  | ![Home screen](media/home_screen.png) | ![User profile](media/user_profile.png) | ![Theme selection](media/theme_selection.png) |
</details>

## About

This project aims to provide a good example for a medium-big sized Flutter app
in hopes that it will be useful for some.

Some interesting features of the app include:

* [flutter_bloc](https://pub.dev/packages/flutter_bloc) for the main state management.
* [get_it](https://pub.dev/packages/get_it) as a service provider that includes
  the ability to navigate and to show on screen messages from anywhere in the app.
* [firebase_analytics](https://pub.dev/packages/firebase_analytics) for
  analytics.
* [sentry](https://pub.dev/packages/sentry) as an online error tracking service
  where users can send a crash report when an exception has not been handled in
  the app.
* Fully featured theme customization.
* Fully featured video player using the
  [video_player](https://pub.dev/packages/video_player) package.
* A 'pro' and 'free' android
  [product flavor](https://developer.android.com/studio/build/build-variants).

## Development / Setup

Harpy is being released in the Play Store for Android, therefore only
Android devices are used for testing the builds.

### Twitter API key

Get your [Twitter API](https://developer.twitter.com/en/docs) key
[here](https://developer.twitter.com/en/apply-for-access).

### Building

The app can be built with the "free" or "pro" flavor by running:

* `flutter run --flavor free --dart-define=flavor=free --dart-define=twitter_consumer_key=your_consumer_key --dart-define=twitter_consumer_secret=your_consumer_secret`
* `flutter run --flavor pro --dart-define=flavor=pro --dart-define=twitter_consumer_key=your_consumer_key --dart-define=twitter_consumer_secret=your_consumer_secret`

### Misc

To generate [json_serializable](https://pub.dev/packages/json_serializable)
models:

* `flutter packages pub run build_runner build`
