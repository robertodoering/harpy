# Harpy

Harpy is a feature rich twitter experience built in
[Flutter](https://flutter.dev/).

Currently still in development. See the
[project](https://github.com/robertodoering/harpy/projects/1) for more
information about the progress.

---

<center>

## Become a beta tester for Harpy

##### Any feedback is welcome

[<img alt='Get it on Google Play'
src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'
width="200"/>](https://play.google.com/apps/testing/com.robertodoering.harpy.free)
</center>

---

## Showcase

(Subject to change)

| Login | Setup |
| :---: | :---: |
| `login_screen.dart` | `setup_screen.dart` |
| ![Login screen](media/login_screen.gif) | ![Setup screen](media/setup_screen.gif) |

<details>
  <summary>More images</summary>
  
  | Home | User profile | Theme selection |
  | :---: | :---: | :---: |
  | ![Home screen](media/home_screen.png) | ![User profile](media/user_profile.png) | ![Theme selection](media/theme_selection.png) |
</details>

## Development / Setup

Harpy is expected to be released in the PlayStore for Android, therefore only
Android devices are used for testing the builds.

### Twitter API key

Get your [Twitter API](https://developer.twitter.com/en/docs) key
[here](https://developer.twitter.com/en/apply-for-access).

- Create a yaml file `app_config.yaml` in [`assets/config/`](assets/config) with
  the key and secret.

```yaml
twitter:
    consumerKey: "your key"
    consumerSecret: "your secret"
```

### Sentry

The [Sentry](https://sentry.io) error tracking service is used to report errors
in release mode.

- The DSN provided by Sentry can be entered in the `app_config.yaml` in
  [`assets/config/`](assets/config).

```yaml
sentry:
    dsn: "your dsn"
```

When omitted or left empty, errors are not sent to an error tracking service in
release mode.

### Building

The app can be built with the 'free' or 'pro' flavor by running:

- `flutter run --flavor free -t lib/main_free.dart`
- `flutter run --flavor pro -t lib/main_pro.dart`

An appbundle for release can be built using:

- `flutter build appbundle --flavor free -t lib/main_free.dart --bundle-sksl-path sksl.json`
- `flutter build appbundle --flavor pro -t lib/main_pro.dart --bundle-sksl-path sksl.json`

### Misc

To generate json_serializable models:

- `flutter packages pub run build_runner build`
