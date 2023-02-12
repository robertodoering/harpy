import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Builds the third page for the [SetupPage].
class SetupFinishContent extends ConsumerWidget {
  const SetupFinishContent({
    required this.connections,
    required this.notifier,
  });

  final BuiltSet<LegacyUserConnection>? connections;
  final LegacyUserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: theme.spacing.edgeInsets,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _CrashReports(),
                VerticalSpacer.normal,
                VerticalSpacer.normal,
                const _HideSensitiveMedia(),
                VerticalSpacer.normal,
                VerticalSpacer.normal,
                _FollowHarpy(connections: connections, notifier: notifier),
              ],
            ),
          ),
          if (isPro)
            Padding(
              padding: theme.spacing.edgeInsets,
              child: Center(
                child: RbyButton.text(
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
    final general = ref.watch(generalPreferencesProvider);
    final generalNotifier = ref.watch(generalPreferencesProvider.notifier);

    return Card(
      child: RbySwitchTile(
        value: general.crashReports,
        borderRadius: theme.shape.borderRadius,
        title: Text(
          'send automatic crash reports',
          style: theme.textTheme.headlineSmall,
          maxLines: 2,
        ),
        subtitle: Text(
          'anonymously report errors to improve harpy',
          style: theme.textTheme.titleSmall,
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
    final media = ref.watch(mediaPreferencesProvider);
    final mediaNotifier = ref.watch(mediaPreferencesProvider.notifier);

    return Card(
      child: RbySwitchTile(
        value: media.hidePossiblySensitive,
        borderRadius: theme.shape.borderRadius,
        title: Text(
          'hide possibly sensitive media',
          style: theme.textTheme.headlineSmall,
          maxLines: 2,
        ),
        onChanged: mediaNotifier.setHidePossiblySensitive,
      ),
    );
  }
}

class _FollowHarpy extends StatelessWidget {
  const _FollowHarpy({
    required this.connections,
    required this.notifier,
  });

  final BuiltSet<LegacyUserConnection>? connections;
  final LegacyUserConnectionsNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: RbySwitchTile(
        value: connections?.contains(LegacyUserConnection.following) ?? false,
        borderRadius: theme.shape.borderRadius,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'follow '),
              TextSpan(
                text: '@harpy_app',
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          style: theme.textTheme.headlineSmall,
        ),
        onChanged: (value) {
          HapticFeedback.lightImpact();
          (connections?.contains(LegacyUserConnection.following) ?? false)
              ? notifier.unfollow('harpy_app')
              : notifier.follow('harpy_app');
        },
      ),
    );
  }
}
