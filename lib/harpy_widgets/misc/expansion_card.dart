import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// A card which can collapse to hide its children.
///
/// Similar to the material [ExpansionPanel].
class ExpansionCard extends StatefulWidget {
  const ExpansionCard({
    required this.title,
    required this.children,
    this.initiallyCollapsed = false,
  });

  final Widget title;
  final List<Widget> children;
  final bool initiallyCollapsed;

  @override
  State<ExpansionCard> createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard> {
  late bool _collapsed;

  @override
  void initState() {
    super.initState();

    _collapsed = widget.initiallyCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => setState(() => _collapsed = !_collapsed),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: config.edgeInsets,
                    child: DefaultTextStyle(
                      style: theme.textTheme.subtitle2!,
                      child: widget.title,
                    ),
                  ),
                ),
                HarpyButton.flat(
                  padding: EdgeInsets.symmetric(
                    vertical: config.paddingValue,
                    horizontal: config.paddingValue * 2,
                  ),
                  icon: AnimatedRotation(
                    duration: kShortAnimationDuration,
                    curve: Curves.easeOut,
                    turns: _collapsed ? .5 : 0,
                    child: const Icon(CupertinoIcons.chevron_down),
                  ),
                  onTap: () => setState(() => _collapsed = !_collapsed),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: kShortAnimationDuration,
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeOutCubic,
            crossFadeState: _collapsed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: AnimatedScale(
              duration: kShortAnimationDuration,
              scale: _collapsed ? .95 : 1,
              curve: Curves.easeInOut,
              child: Column(children: widget.children),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
