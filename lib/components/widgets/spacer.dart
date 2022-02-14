import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

const horizontalSpacer = _Spacer(axis: Axis.horizontal);
const smallHorizontalSpacer = _SmallSpacer(axis: Axis.horizontal);

const verticalSpacer = _Spacer(axis: Axis.vertical);
const smallVerticalSpacer = _SmallSpacer(axis: Axis.vertical);

class _Spacer extends ConsumerWidget {
  const _Spacer({
    required this.axis,
  });

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(displayPreferencesProvider).paddingValue;

    return SizedBox(
      width: axis == Axis.horizontal ? value : null,
      height: axis == Axis.vertical ? value : null,
    );
  }
}

class _SmallSpacer extends ConsumerWidget {
  const _SmallSpacer({
    required this.axis,
  });

  final Axis axis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(displayPreferencesProvider).smallPaddingValue;

    return SizedBox(
      width: axis == Axis.horizontal ? value : null,
      height: axis == Axis.vertical ? value : null,
    );
  }
}
