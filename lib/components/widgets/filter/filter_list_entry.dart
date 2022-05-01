import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

// FIXME: refactor

class FilterListEntry extends ConsumerStatefulWidget {
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

class _FilterListEntryState extends ConsumerState<FilterListEntry> {
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
    _controller.dispose();

    super.dispose();
  }

  List<Widget> _buildActiveFilters(
    ThemeData theme,
    DisplayPreferences display,
  ) {
    if (widget.activeFilters.isNotEmpty) {
      final foregroundColor = theme.colorScheme.onSecondary;
      final backgroundColor = theme.colorScheme.secondary;

      return [
        smallVerticalSpacer,
        Wrap(
          spacing: display.smallPaddingValue,
          runSpacing: display.smallPaddingValue,
          children: [
            for (int i = 0; i < widget.activeFilters.length; i++)
              ImmediateOpacityAnimation(
                duration: kShortAnimationDuration,
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
      child = HarpyButton.icon(
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
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: display.edgeInsetsSymmetric(horizontal: true),
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
          ..._buildActiveFilters(theme, display),
        ],
      ),
    );
  }
}
