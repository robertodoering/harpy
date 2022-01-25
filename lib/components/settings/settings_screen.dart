import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  static const route = 'settings';

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return HarpyScaffold(
      body: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(
            title: 'settings',
            floating: true,
          ),
          SliverPadding(
            padding: config.edgeInsets,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _TweetSettingsCard(),
                verticalSpacer,
                _AppearanceSettingsCard(),
                verticalSpacer,
                _OtherSettingsCard(),
              ]),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _TweetSettingsCard extends StatelessWidget {
  const _TweetSettingsCard();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      title: const Text('tweet'),
      children: [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.photo),
          title: const Text('media'),
          subtitle: const Text('settings for videos, images and gifs'),
          borderRadius: const BorderRadius.only(
            bottomLeft: kRadius,
            bottomRight: kRadius,
          ),
          onTap: () => app<HarpyNavigator>().pushNamed(
            MediaSettingsScreen.route,
          ),
        ),
      ],
    );
  }
}

class _AppearanceSettingsCard extends StatelessWidget {
  const _AppearanceSettingsCard();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      title: const Text('appearance'),
      children: [
        HarpyListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('theme'),
          subtitle: const Text('select your theme'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            ThemeSelectionScreen.route,
          ),
        ),
        HarpyListTile(
          leading: const Icon(FeatherIcons.layout),
          title: const Text('display'),
          subtitle: const Text('change the look of the app'),
          borderRadius: const BorderRadius.only(
            bottomLeft: kRadius,
            bottomRight: kRadius,
          ),
          onTap: () => app<HarpyNavigator>().pushNamed(
            DisplaySettingsScreen.route,
          ),
        ),
      ],
    );
  }
}

class _OtherSettingsCard extends StatelessWidget {
  const _OtherSettingsCard();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      title: const Text('other'),
      children: [
        HarpyListTile(
          leading: const Icon(FeatherIcons.sliders),
          title: const Text('general'),
          onTap: () => app<HarpyNavigator>().pushNamed(
            GeneralSettingsScreen.route,
          ),
        ),
        HarpyListTile(
          leading: const Icon(Icons.translate),
          title: const Text('language'),
          borderRadius: const BorderRadius.only(
            bottomLeft: kRadius,
            bottomRight: kRadius,
          ),
          onTap: () => app<HarpyNavigator>().pushNamed(
            LanguageSettingsScreen.route,
          ),
        ),
      ],
    );
  }
}
