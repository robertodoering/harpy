import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Displays the location of currently displayed trends by the parent
/// [TrendsCubit] and allows for the user to configure the trend location.
class TrendsCard extends StatelessWidget {
  const TrendsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<TrendsCubit>();
    final state = cubit.state;

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: Row(
        children: [
          Expanded(
            child: HarpyListCard(
              leading: Icon(
                CupertinoIcons.location,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                state.locationName,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onTap: () => _showTrendsConfiguration(context),
            ),
          ),
          horizontalSpacer,
          HarpyButton.raised(
            padding: config.edgeInsets,
            elevation: 0,
            backgroundColor: theme.cardTheme.color,
            icon: const Icon(CupertinoIcons.refresh),
            onTap: state.isLoading
                ? null
                : () {
                    ScrollDirection.of(context)?.reset();
                    cubit.findTrends();
                  },
          )
        ],
      ),
    );
  }
}

void _showTrendsConfiguration(BuildContext context) {
  final cubit = context.read<TrendsCubit>();

  showHarpyBottomSheet<void>(
    context,
    children: [
      BottomSheetHeader(
        child: Text(cubit.state.locationName),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TrendsLocationsCubit>()),
          BlocProvider.value(value: cubit),
        ],
        child: const SelectLocationListTile(),
      ),
      HarpyListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('find location'),
        onTap: () {
          Navigator.of(context).pop();
          showDialog<void>(
            context: context,
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => FindTrendsLocationsBloc()),
                BlocProvider.value(value: cubit),
              ],
              child: const FindLocationDialog(),
            ),
          );
        },
      ),
    ],
  );
}
