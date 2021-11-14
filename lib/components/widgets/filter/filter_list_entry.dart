import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class FilterListEntry extends StatefulWidget {
  const FilterListEntry({
    required this.labelText,
    required this.activeFilters,
    required this.onSubmitted,
    required this.onDeleted,
  });

  final String labelText;
  final List<String> activeFilters;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<int> onDeleted;

  @override
  _FilterListEntryState createState() => _FilterListEntryState();
}

class _FilterListEntryState extends State<FilterListEntry> {
  final TextEditingController _controller = TextEditingController();

  bool _showAddButton = false;

  @override
  void initState() {
    super.initState();

    // rebuild to show / hide the add buttons
    _controller.addListener(() {
      if (_showAddButton != _controller.value.text.isNotEmpty) {
        setState(() => _showAddButton = !_showAddButton);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  List<Widget> _buildActiveFilters(Config config, ThemeData theme) {
    if (widget.activeFilters.isNotEmpty) {
      final foregroundColor = theme.colorScheme.onSecondary;
      final backgroundColor = theme.colorScheme.secondary;

      return [
        smallVerticalSpacer,
        Wrap(
          spacing: config.smallPaddingValue,
          runSpacing: config.smallPaddingValue,
          children: [
            for (int i = 0; i < widget.activeFilters.length; i++)
              FadeAnimation(
                child: Chip(
                  backgroundColor: backgroundColor,
                  deleteIconColor: foregroundColor,
                  label: Text(
                    widget.activeFilters[i],
                    style: TextStyle(color: foregroundColor),
                  ),
                  deleteIcon: const Icon(CupertinoIcons.xmark, size: 14),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onDeleted: () => widget.onDeleted(i),
                ),
              )
          ],
        )
      ];
    } else {
      return [];
    }
  }

  Widget _buildSuffixButton() {
    Widget child;

    if (_showAddButton) {
      child = HarpyButton.flat(
        dense: true,
        icon: const Icon(CupertinoIcons.add),
        onTap: _controller.text.isEmpty
            ? null
            : () {
                widget.onSubmitted(_controller.text);
                _controller.clear();
              },
      );
    } else {
      child = const SizedBox();
    }

    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: const TextStyle(fontSize: 14),
                    isDense: true,
                    suffixIcon: _buildSuffixButton(),
                  ),
                  onSubmitted: (text) {
                    widget.onSubmitted(text);
                    _controller.clear();
                  },
                ),
              ),
            ],
          ),
          ..._buildActiveFilters(config, theme),
        ],
      ),
    );
  }
}
