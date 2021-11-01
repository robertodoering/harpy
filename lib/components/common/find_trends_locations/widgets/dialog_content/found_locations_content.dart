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
    final trendsBloc = context.watch<TrendsBloc>();

    final bloc = context.watch<FindTrendsLocationsBloc>();
    final state = bloc.state;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.hasLocations) {
      final locations = state.locations;

      if (!locations.contains(TrendsLocationData.worldwide)) {
        locations.insert(0, TrendsLocationData.worldwide);
      }

      return Column(
        children: [
          for (final location in locations)
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
                trendsBloc.add(UpdateTrendsLocation(location: location));
              },
            ),
        ],
      );
    } else if (state.hasServiceDisabled) {
      return Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('location service is unavailable'),
        ),
      );
    } else if (state.hasPermissionsDenied) {
      return Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('location permissions have been denied'),
        ),
      );
    } else {
      return Padding(
        padding: config.edgeInsets,
        child: const Center(
          child: Text('no locations found'),
        ),
      );
    }
  }
}
