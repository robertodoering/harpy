import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

/// Content for the [FindLocationDialog] when locations have been searched for.
class FoundLocationsContent extends StatelessWidget {
  const FoundLocationsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trendsBloc = context.watch<TrendsBloc>();

    final bloc = context.watch<FindTrendsLocationsBloc>();
    final state = bloc.state;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.hasLocations) {
      return Column(
        children: [
          for (final location in state.locations)
            ListTile(
              leading: const Icon(CupertinoIcons.location),
              title: Text(location.name),
              subtitle: Text(location.placeType.toLowerCase()),
              onTap: () {
                Navigator.of(context).pop();
                unawaited(HapticFeedback.lightImpact());
                trendsBloc.add(UpdateTrendsLocation(location: location));
              },
            ),
        ],
      );
    } else {
      return const Text('no locations found');
    }
  }
}
