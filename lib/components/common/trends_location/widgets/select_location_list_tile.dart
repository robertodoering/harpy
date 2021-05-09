import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
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

  Widget _buildTrailing(TrendsLocationBloc bloc, TrendsLocationState state) {
    Widget child;

    if (state.isLoading) {
      child = const CircularProgressIndicator();
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
    final bloc = context.watch<TrendsLocationBloc>();
    final state = bloc.state;

    return RadioDialogTile<TrendsLocationData>(
      // todo: value from prefs
      value: const TrendsLocationData(
        woeid: 0,
        name: 'worldwide',
        placeType: 'world',
      ),
      leading: CupertinoIcons.list_bullet,
      title: 'select location',
      trailing: _buildTrailing(bloc, state),
      description: 'change the trends location',
      denseRadioTiles: true,
      titles: state.locations.map((e) => e.name).toList(),
      values: state.locations,
      enabled: state.hasLocations,
      popOnOpen: true,
      onChanged: (_) {}, // todo: confirm selection
    );
  }
}
