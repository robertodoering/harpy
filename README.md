<p align="center">
  <img max-height="172" width="80%" src="media/title.png"/>
</p>

<p align="center">
a feature rich Twitter experience built with <a href="https://flutter.dev/">Flutter</a>, continued
</p>
  
<br>

<p align="center">
  <a href="https://github.com/armand0w/harpy/stargazers"><img src="https://img.shields.io/github/stars/armand0w/harpy?color=8B00FD&logo=github"/></a>
  <a href="https://github.com/armand0w/harpy/releases"><img src="https://img.shields.io/github/v/release/armand0w/harpy?color=BC0492"/></a>
  <a href="https://github.com/armand0w/harpy/commits/master"><img src="https://img.shields.io/github/commits-since/armand0w/harpy/latest?color=F2091C"/></a>
  <a href="https://github.com/armand0w/harpy/commits/master"><img src="https://img.shields.io/github/commit-activity/m/armand0w/harpy?color=FD0A04"/></a>
</p>
<p align="center">
  <a href="https://github.com/Solido/awesome-flutter">
   <img src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true"/>
  </a>

</p>

<br>

<p align="center">
The orignal harpy is no longer in active development after Twitter's decision to disallow third party Twitter clients. This fork continues that.
</p>

<p align="center">
harpy was a twitter client that used to be available in the Play Store as a free and paid app that was used by over 75k active users.
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

**harpy** was an alternative Twitter client that focused on a nice user experience with unique features. This project continues it's legacy.

The project has been in development since late 2018 and aims to be a good example for a medium-large sized Flutter app with a focus on code quality and maintainability.

Some interesting features of the app include:

* [riverpod](https://pub.dev/packages/riverpod)
  * for state management using the included [state_notifier](https://pub.dev/packages/state_notifier)
  * for dependency injection / service locators with easily mockable dependencies
* [go_router](https://pub.dev/packages/go_router) for routing with support for Twitter url deeplinks
* [sentry](https://pub.dev/packages/sentry) as an online error tracking service to report unhandled exceptions
* Fully featured theme customization
* Fully featured video player using the
  [video_player](https://pub.dev/packages/video_player) package
* Robertodoering's own [twitter_api](https://github.com/robertodoering/twitter_api) package to make use of the official Twitter api
* Many customized animations sprinkled around the app, including custom logo animations created with [Rive](https://flare.rive.app/a/rbyd/files/recent/all)

### Development / Setup

Follow the [project setup for building harpy](https://github.com/armand0w/harpy/wiki/Project-setup-for-building-harpy) instructions to get the project running.
