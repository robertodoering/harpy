import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

/// Content for the [FindLocationDialog] when locations have been searched for.
class FoundLocationsContent extends StatelessWidget {
  const FoundLocationsContent();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final trendsCubit = context.watch<TrendsCubit>();

    final bloc = context.watch<FindTrendsLocationsBloc>();
    final state = bloc.state;

    return state.maybeWhen(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (locations) {
        final allLocations = locations.toList();

        if (!allLocations.contains(TrendsLocationData.worldwide)) {
          allLocations.insert(0, TrendsLocationData.worldwide);
        }

        return Column(
          children: [
            for (final location in allLocations)
              ListTile(
                leading: const Icon(CupertinoIcons.location),
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(location.name),
                subtitle: location.isTown && location.hasCountry
                    ? Text(location.country)
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  HapticFeedback.lightImpact();
                  trendsCubit.updateLocation(location: location);
                },
              ),
          ],
        );
      },
      serviceDisabled: () => Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('location service is unavailable'),
        ),
      ),
      permissionDenied: () => Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('location permissions have been denied'),
        ),
      ),
      orElse: () => Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('no locations found'),
        ),
      ),
    );
  }
}
