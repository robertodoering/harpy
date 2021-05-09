import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Displays the location of currently displayed trends by the parent
/// [TrendsBloc] and allows for the user to configure the trend location.
class TrendsCard extends StatelessWidget {
  const TrendsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bloc = context.watch<TrendsBloc>();
    final state = bloc.state;

    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: Card(
        child: CustomAnimatedSize(
          alignment: Alignment.topCenter,
          child: ListTile(
            shape: kDefaultShapeBorder,
            leading: Icon(
              CupertinoIcons.location,
              color: theme.accentColor,
            ),
            title: Text(
              state.trendLocationName,
              style: TextStyle(color: theme.accentColor),
            ),
            onTap: () => _showTrendsConfiguration(context),
          ),
        ),
      ),
    );
  }
}

void _showTrendsConfiguration(BuildContext context) {
  final trendsBloc = context.read<TrendsBloc>();

  showHarpyBottomSheet<void>(
    context,
    children: [
      BottomSheetHeader(
        child: Text(trendsBloc.state.trendLocationName),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TrendsLocationsBloc>()),
          BlocProvider.value(value: trendsBloc),
        ],
        child: const SelectLocationListTile(),
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.search),
        title: const Text('find location'),
        onTap: () {
          Navigator.of(context).pop();
          showDialog<void>(
            context: context,
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => FindTrendsLocationsBloc()),
                BlocProvider.value(value: trendsBloc),
              ],
              child: const FindLocationDialog(),
            ),
          );
        },
      ),
    ],
  );
}
