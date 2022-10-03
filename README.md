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
harpy is in active development. Check out the <a href="https://github.com/robertodoering/harpy/projects/1">project</a> for more
information about upcoming features.
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

**harpy** is an alternative Twitter client that focuses on a nice user experience with unique features.

This project has been in development since 2018 and aims to be a good example for a medium-large sized Flutter app with a focus on code quality and maintainability.

It's currently available on the PlayStore as a [free](https://play.google.com/store/apps/details?id=com.robertodoering.harpy.free) and a paid [pro](https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro) version and is used by over 50.000 users.

Some interesting features of the app include:

* [riverpod](https://pub.dev/packages/riverpod)
  * for state management using the included [state_notifier](https://pub.dev/packages/state_notifier)
  * for dependency injection / service locators with easily mockable dependencies
* [go_router](https://pub.dev/packages/go_router) for routing with support for Twitter url deeplinks
* [sentry](https://pub.dev/packages/sentry) as an online error tracking service to report unhandled exceptions
* Fully featured theme customization
* Fully featured video player using the
  [video_player](https://pub.dev/packages/video_player) package
* My own [twitter_api](https://github.com/robertodoering/twitter_api) package to make use of the official Twitter api
* A 'pro' and 'free' android
  [product flavor](https://developer.android.com/studio/build/build-variants)
* Many customized animations sprinkled around the app, including custom logo animations created with [Rive](https://flare.rive.app/a/rbyd/files/recent/all)

### Contributing

Contributions are welcome! Check out the [contributing guidelines](https://github.com/robertodoering/harpy/blob/master/CONTRIBUTING.md).

### Development / Setup

Follow the [Project setup for building harpy](https://github.com/robertodoering/harpy/wiki/Project-setup-for-building-harpy) instructions to get the project running.
