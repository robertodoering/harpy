import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage();

  static const name = 'language_settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('language')),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
            sliver: const _LanguageSettingsList(),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _LanguageSettingsList extends ConsumerWidget {
  const _LanguageSettingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SliverList(
      delegate: SliverChildListDelegate.fixed([
        Card(child: TranslateLanguagesDialogTile()),
        VerticalSpacer.normal,
        RbyListCard(
          leading: Icon(Icons.translate),
          title: Text('app language'),
          subtitle: Text('coming soon!'),
          enabled: false,
        ),
      ]),
    );
  }
}
