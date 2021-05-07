import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Displays the location of currently displayed trends by the parent
/// [TrendsBloc] and allows for the user to configure the trend location.
class TrendsHeader extends StatelessWidget {
  const TrendsHeader({
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
          child: ListTile(
            shape: kDefaultShapeBorder,
            leading: Icon(
              CupertinoIcons.location,
              color: theme.accentColor,
            ),
            title: Text(
              'worldwide trends',
              style: TextStyle(color: theme.accentColor),
            ),
            subtitle:
                state.hasTrends ? Text('${state.trendsCount} trends') : null,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
