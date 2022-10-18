import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class FoundTrendsLocations extends ConsumerWidget {
  const FoundTrendsLocations();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trendsNotifier = ref.watch(trendsProvider.notifier);
    final state = ref.watch(findTrendsLocationProvider);

    return RbyAnimatedSwitcher(
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ...previousChildren,
          if (currentChild != null) currentChild,
        ],
      ),
      child: state.maybeWhen(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (locations) => SingleChildScrollView(
          child: Column(
            children: [
              for (final location in locations)
                RbyListTile(
                  leading: const Icon(FeatherIcons.mapPin),
                  title: Text(location.name),
                  subtitle: location.isTown && location.country != null
                      ? Text(location.country!)
                      : null,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                    trendsNotifier.updateLocation(location: location);
                  },
                ),
            ],
          ),
        ),
        serviceDisabled: () => Padding(
          padding: theme.spacing.edgeInsets,
          child: const Center(
            child: Text('location service is unavailable'),
          ),
        ),
        permissionDenied: () => Padding(
          padding: theme.spacing.edgeInsets,
          child: const Center(
            child: Text('location permissions have been denied'),
          ),
        ),
        orElse: () => Padding(
          padding: theme.spacing.edgeInsets,
          child: const Center(
            child: Text('no locations found'),
          ),
        ),
      ),
    );
  }
}
