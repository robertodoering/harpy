<p align="center">
  <img max-height="172" width="80%" src="media/title.png"/>
</p>

<p align="center">
a feature rich Twitter experience built with <a href="https://flutter.dev/">Flutter</a>
</p>

<p align="center">
  <a href="https://play.google.com/apps/testing/com.robertodoering.harpy.free" target="_blank">
    <img alt="Get it on Google Play"
         src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
         width="200"/>
  </a>
</p>
  
<br>

<p align="center">
  <a href="https://github.com/robertodoering/harpy/stargazers"><img src="https://img.shields.io/github/stars/robertodoering/harpy?color=8B00FD&logo=github"/></a>
  <a href="https://github.com/robertodoering/harpy/releases"><img src="https://img.shields.io/github/v/release/robertodoering/harpy?color=BC0492"/></a>
  <a href="https://play.google.com/store/apps/details?id=com.robertodoering.harpy.free"><img src="https://img.shields.io/endpoint?color=DE0747&logo=google-play&logoColor=BC0492&url=https%3A%2F%2Fplayshields.herokuapp.com%2Fplay%3Fi%3Dcom.robertodoering.harpy.free%26l%3Dinstalls%26m%3D%24installs"/></a>
  <a href="https://github.com/robertodoering/harpy/commits/master"><img src="https://img.shields.io/github/commits-since/robertodoering/harpy/latest?color=F2091C"/></a>
  <a href="https://github.com/robertodoering/harpy/commits/master"><img src="https://img.shields.io/github/commit-activity/m/robertodoering/harpy?color=FD0A04"/></a>
</p>
<p align="center">
  <a href="https://github.com/Solido/awesome-flutter">
   <img src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true"/>
  </a>
  
  <a href="https://github.com/robertodoering/harpy/actions/workflows/flutter_pr.yml">
   <img src="https://github.com/robertodoering/harpy/actions/workflows/flutter_pr.yml/badge.svg"/>
  </a>
</p>

<br>

<p align="center">
harpy is currently still in development. See the <a href="https://github.com/robertodoering/harpy/projects/1">project</a> for more
information about the progress
</p>

<br>

<p align="center">
  <a href="https://ko-fi.com/robertodoering" target="_blank"><img height="35" src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com'></a>
</p>

<br>

<p align="center">
  <kbd><img height="480" src="media/login_screen.gif"/></kbd>
  <kbd><img height="480" src="media/setup_screen.gif"/></kbd>
</p>

<details>
  <summary>More images</summary>
  
  | **Home** | **Media timeline** | **Theme selection** |
  | :---: | :---: | :---: |
  | <kbd><img src="media/timeline.jpg"/></kbd> | <kbd><img src="media/media_timeline.jpg"/></kbd> | <kbd><img src="media/theme_selection.jpg"/></kbd> |
  | **Menu** | **Trends** | **Tweet search filter** |
  | <kbd><img src="media/drawer.jpg"/></kbd> | <kbd><img src="media/trends.jpg"/></kbd> | <kbd><img src="media/tweet_search_filter.jpg"/></kbd> |
</details>

## About

Harpy is a fully featured Twitter client that focuses on great UI/UX and a clean experience.

This project aims to provide a good example for a medium-big sized Flutter app
in hopes that it will be useful for some.

Some interesting features of the app include:

* [flutter_bloc](https://pub.dev/packages/flutter_bloc) for the main state management, using blocs and cubits.
* [get_it](https://pub.dev/packages/get_it) as a service provider that includes
  the ability to navigate and to show on screen messages from anywhere in the app.
* [sentry](https://pub.dev/packages/sentry) as an online error tracking service to report unhandled exceptions.
* Fully featured theme customization.
* Fully featured video player using the
  [video_player](https://pub.dev/packages/video_player) package.
* A 'pro' and 'free' android
  [product flavor](https://developer.android.com/studio/build/build-variants).


### Development / Setup

Harpy is being released in the Play Store for Android, therefore only
Android devices are used for testing the builds.

Run the build runner once after cloning the project
- `flutter packages pub run build_runner build`

### Twitter API key

Follow [these instructions](https://github.com/robertodoering/harpy/wiki/Twitter-key-setup) for setting up your Twitter API key.

### Building

The app can be built with the "free" or "pro" flavor by running:

* `flutter run --flavor free --dart-define=flavor=free --dart-define=twitter_consumer_key=your_consumer_key --dart-define=twitter_consumer_secret=your_consumer_secret`
* `flutter run --flavor pro --dart-define=flavor=pro --dart-define=twitter_consumer_key=your_consumer_key --dart-define=twitter_consumer_secret=your_consumer_secret`
