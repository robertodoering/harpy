import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

const defaultHorizontalSpacer = DefaultSpacer(axis: Axis.horizontal);
const defaultSmallHorizontalSpacer = DefaultSpacer(
  axis: Axis.horizontal,
  factor: .5,
);

const defaultVerticalSpacer = DefaultSpacer(axis: Axis.vertical);
const defaultSmallVerticalSpacer = DefaultSpacer(
  axis: Axis.vertical,
  factor: .5,
);

class DefaultSpacer extends StatelessWidget {
  const DefaultSpacer({
    required this.axis,
    this.factor = 1,
  });

  final Axis axis;
  final double factor;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    final paddingValue = config.paddingValue * factor;

    return SizedBox(
      width: axis == Axis.horizontal ? paddingValue : 0,
      height: axis == Axis.vertical ? paddingValue : 0,
    );
  }
}
