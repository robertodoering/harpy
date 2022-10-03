import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Builds the third page for the [SetupPage].
class SetupFinishContent extends ConsumerWidget {
  const SetupFinishContent({
    required this.connections,
    required this.notifier,
  });

  final BuiltSet<UserConnection>? connections;
  final UserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: display.edgeInsets,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _CrashReports(),
                verticalSpacer,
                verticalSpacer,
                const _HideSensitiveMedia(),
                verticalSpacer,
                verticalSpacer,
                _FollowHarpy(connections: connections, notifier: notifier),
              ],
            ),
          ),
          if (isPro)
            Padding(
              padding: display.edgeInsets,
              child: Center(
                child: HarpyButton.text(
                  label: const Text('finish setup'),
                  onTap: () => finishSetup(ref),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CrashReports extends ConsumerWidget {
  const _CrashReports();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final general = ref.watch(generalPreferencesProvider);
    final generalNotifier = ref.watch(generalPreferencesProvider.notifier);

    return Card(
      child: HarpySwitchTile(
        value: general.crashReports,
        borderRadius: harpyTheme.borderRadius,
        title: Text(
          'send automatic crash reports',
          style: theme.textTheme.headline5,
          maxLines: 2,
        ),
        subtitle: Text(
          'anonymously report errors to improve harpy',
          style: theme.textTheme.subtitle2,
        ),
        onChanged: generalNotifier.setCrashReports,
      ),
    );
  }
}

class _HideSensitiveMedia extends ConsumerWidget {
  const _HideSensitiveMedia();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final media = ref.watch(mediaPreferencesProvider);
    final mediaNotifier = ref.watch(mediaPreferencesProvider.notifier);

    return Card(
      child: HarpySwitchTile(
        value: media.hidePossiblySensitive,
        borderRadius: harpyTheme.borderRadius,
        title: Text(
          'hide possibly sensitive media',
          style: theme.textTheme.headline5,
          maxLines: 2,
        ),
        onChanged: mediaNotifier.setHidePossiblySensitive,
      ),
    );
  }
}

class _FollowHarpy extends ConsumerWidget {
  const _FollowHarpy({
    required this.connections,
    required this.notifier,
  });

  final BuiltSet<UserConnection>? connections;
  final UserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    return Card(
      child: HarpySwitchTile(
        value: connections?.contains(UserConnection.following) ?? false,
        borderRadius: harpyTheme.borderRadius,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'follow '),
              TextSpan(
                text: '@harpy_app',
                style: theme.textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          style: theme.textTheme.headline5,
        ),
        onChanged: (value) {
          HapticFeedback.lightImpact();
          (connections?.contains(UserConnection.following) ?? false)
              ? notifier.unfollow('harpy_app')
              : notifier.follow('harpy_app');
        },
      ),
    );
  }
}
