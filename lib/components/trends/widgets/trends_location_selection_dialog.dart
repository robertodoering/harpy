import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/trends/provider/trends_locations_provider.dart';

/// Builds a list of predetermined trends locations that are provided by
/// Twitter.
///
/// Only countries are displayed in the list.
class TrendsLocationSelectionDialog extends ConsumerStatefulWidget {
  const TrendsLocationSelectionDialog();

  @override
  _LocationSelectionDialogState createState() =>
      _LocationSelectionDialogState();
}

class _LocationSelectionDialogState
    extends ConsumerState<TrendsLocationSelectionDialog> {
  String _filter = '';

  Iterable<TrendsLocationData> filteredLocations(
    BuiltList<TrendsLocationData>? locations,
  ) {
    return [TrendsLocationData.worldwide(), ...?locations].where(
      (location) => location.name.toLowerCase().contains(_filter.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final trendsNotifier = ref.watch(trendsProvider.notifier);
    final userLocation = ref.watch(userTrendsLocationProvider);
    final locations = ref.watch(trendsLocationsProvider);

    return HarpyDialog(
      title: const Text('change the trends location'),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      stickyContent: Padding(
        padding: display.edgeInsets,
        child: TextField(
          decoration: InputDecoration(hintText: userLocation.name),
          onChanged: (value) => setState(() => _filter = value),
        ),
      ),
      content: Column(
        children: [
          for (final location in filteredLocations(locations.asData?.value))
            HarpyRadioTile<TrendsLocationData>(
              title: Text(location.name),
              value: location,
              groupValue: userLocation,
              leadingPadding: display.edgeInsets / 4,
              contentPadding: display.edgeInsets / 4,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                if (value != userLocation) {
                  trendsNotifier.updateLocation(location: value);
                }
              },
            ),
          if (locations is AsyncLoading)
            Container(
              padding: display.edgeInsets,
              alignment: AlignmentDirectional.center,
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
