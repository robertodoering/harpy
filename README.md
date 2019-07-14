# Harpy

Harpy is a feature rich twitter experience for Android and iOS built in [Flutter](https://flutter.dev/).

Currently still in development.

Showcase
---
###### (Subject to change)

| Login | Setup |
| :---: | :---: |
| `login_screen.dart` | `setup_screen.dart` |
| ![Harpy Login](media/harpy_login.gif)  | ![Harpy Setup](media/harpy_setup.gif)  |

Development / Setup
---

- Twitter API Key
	- Create a yaml file `app_config.yaml` in `assets/config/` with the key and secret.
		```yaml
		twitter:
		  consumerKey: <key>
		  consumerSecret: <secret>
		```

- To generate json_serializable models:
`flutter packages pub run build_runner build`

