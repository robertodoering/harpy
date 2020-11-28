import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/widget/compose_text_cotroller.dart';

/// Builds the [child] as suggestions when the [selectionRegExp] matches the
/// selection.
class ComposeTweetSuggestions extends StatefulWidget {
  const ComposeTweetSuggestions(
    this.bloc, {
    @required this.child,
    @required this.controller,
    @required this.selectionRegExp,
    @required this.onSearch,
  });

  final ComposeBloc bloc;
  final Widget child;
  final ComposeTextController controller;
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

    widget.controller.selectionRecognizers[widget.selectionRegExp] =
        (String value) {
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
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxHeight = mediaQuery.size.height / 3;

    Widget child;

    if (widget.child != null && _showSuggestions) {
      child = Card(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: widget.child,
        ),
      );
    } else {
      child = const SizedBox();
    }

    return CustomAnimatedSize(
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
