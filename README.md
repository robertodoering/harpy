# Harpy

Harpy is a feature rich twitter experience built in [Flutter](https://flutter.dev/).

Currently still in development.

Showcase
---
###### (Subject to change)

| Login | Setup |
| :---: | :---: |
| `login_screen.dart` | `setup_screen.dart` |
| ![Login screen](media/login_screen.gif)  | ![Setup screen](media/setup_screen.gif)  |

| Home | User | Following | Custom theme|
| :---: | :---: |  :---: | :---: |
|![Home screen](media/home_screen.png) | ![User screen](media/user_screen.png) | ![Following screen](media/following_screen.png) |  ![Custom theme screen](media/custom_theme_screen.png) ![Custom theme color selection](media/custom_theme_color_palette.png) ![Custom theme color selection](media/custom_theme_color_picker.png) |

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

