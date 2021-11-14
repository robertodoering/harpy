import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Used to select the location that is used by the [TrendsCubit] to show
/// local trends from the list of predefined locations that twitter has
/// trends for.
///
/// Only countries are shown to keep the list small.
class SelectLocationListTile extends StatelessWidget {
  const SelectLocationListTile();

  Widget _buildTrailing(TrendsLocationsCubit locationCubit) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: kShortAnimationDuration,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: locationCubit.state.maybeMap(
          loading: (_) => const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          error: (_) => HarpyButton.flat(
            padding: const EdgeInsets.all(8),
            icon: const Icon(CupertinoIcons.refresh),
            onTap: locationCubit.load,
          ),
          orElse: () => const SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trendsCubit = context.watch<TrendsCubit>();
    final trendsState = trendsCubit.state;

    final locationCubit = context.watch<TrendsLocationsCubit>();
    final locationState = locationCubit.state;

    return RadioDialogTile<TrendsLocationData>(
      value: trendsState.location ?? TrendsLocationData.worldwide,
      leading: CupertinoIcons.list_bullet,
      title: 'select location',
      trailing: _buildTrailing(locationCubit),
      trailingPadding: EdgeInsets.zero,
      description: 'change the trends location',
      denseRadioTiles: true,
      titles: [
        TrendsLocationData.worldwide,
        ...locationState.locations,
      ].map((e) => e.name).toList(),
      values: [
        TrendsLocationData.worldwide,
        ...locationState.locations,
      ],
      enabled: locationState.hasData,
      popOnOpen: true,
      onChanged: (location) {
        if (location != null) {
          HapticFeedback.lightImpact();
          trendsCubit.updateLocation(location: location);
        }
      },
    );
  }
}
