import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';

/// Used to select the location that is used by the [TrendsBloc] to show
/// local trends from the list of predefined locations that twitter has
/// trends for.
///
/// Only countries are shown to keep the list small.
class SelectLocationListTile extends StatelessWidget {
  const SelectLocationListTile({
    Key? key,
  }) : super(key: key);

  Widget _buildTrailing(TrendsLocationsBloc bloc, TrendsLocationsState state) {
    Widget child;

    if (state.isLoading) {
      child = const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      );
    } else if (state.hasFailed) {
      child = HarpyButton.flat(
        padding: const EdgeInsets.all(8),
        icon: const Icon(CupertinoIcons.refresh),
        onTap: () => bloc.add(const LoadTrendsLocations()),
      );
    } else {
      child = const SizedBox();
    }

    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: kShortAnimationDuration,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trendsBloc = context.watch<TrendsBloc>();
    final trendsState = trendsBloc.state;

    final locationBloc = context.watch<TrendsLocationsBloc>();
    final locationState = locationBloc.state;

    return RadioDialogTile<TrendsLocationData>(
      value: trendsState.location ?? TrendsLocationData.worldwide,
      leading: CupertinoIcons.list_bullet,
      title: 'select location',
      trailing: _buildTrailing(locationBloc, locationState),
      trailingPadding: EdgeInsets.zero,
      description: 'change the trends location',
      denseRadioTiles: true,
      titles: [TrendsLocationData.worldwide]
          .followedBy(locationState.locations)
          .map((e) => e.name)
          .toList(),
      values: [TrendsLocationData.worldwide]
          .followedBy(locationState.locations)
          .toList(),
      enabled: locationState.hasLocations,
      popOnOpen: true,
      onChanged: (location) {
        if (location != null) {
          unawaited(HapticFeedback.lightImpact());
          trendsBloc.add(UpdateTrendsLocation(location: location));
        }
      },
    );
  }
}
