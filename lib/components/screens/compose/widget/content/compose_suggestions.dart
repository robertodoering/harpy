import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the [child] as suggestions when the [selectionRegExp] matches the
/// selection.
class ComposeTweetSuggestions extends StatefulWidget {
  const ComposeTweetSuggestions({
    required this.child,
    required this.controller,
    required this.selectionRegExp,
    required this.onSearch,
  });

  final Widget? child;
  final ComposeTextController? controller;
  final RegExp selectionRegExp;
  final ValueChanged<String> onSearch;

  @override
  _ComposeTweetSuggestionsState createState() =>
      _ComposeTweetSuggestionsState();
}

class _ComposeTweetSuggestionsState extends State<ComposeTweetSuggestions> {
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();

    widget.controller!.selectionRecognizers[widget.selectionRegExp] = (value) {
      if (value == null) {
        // selection does not match
        _changeShowSuggestions(false);
      } else {
        // show suggestions
        widget.onSearch(value);
        _changeShowSuggestions(true);
      }
    };
  }

  void _changeShowSuggestions(bool show) {
    if (mounted && _showSuggestions != show) {
      setState(() {
        _showSuggestions = show;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height / 4;

    Widget child;

    if (widget.child != null && _showSuggestions) {
      child = Padding(
        padding: config.edgeInsets,
        child: Card(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: widget.child,
          ),
        ),
      );
    } else {
      child = const SizedBox();
    }

    return AnimatedSize(
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: kShortAnimationDuration,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
    );
  }
}
