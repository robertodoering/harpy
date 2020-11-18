import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';

/// Listens to the [controller] to start searching for suggestions using the
/// [onSearch] callback after the [identifier] has been typed.
class ComposeTweetSuggestions extends StatefulWidget {
  const ComposeTweetSuggestions(
    this.bloc, {
    @required this.child,
    @required this.controller,
    @required this.identifier,
    @required this.onSearch,
  });

  final ComposeBloc bloc;
  final Widget child;
  final TextEditingController controller;
  final String identifier;
  final ValueChanged<String> onSearch;

  @override
  _ComposeTweetSuggestionsState createState() =>
      _ComposeTweetSuggestionsState();
}

class _ComposeTweetSuggestionsState extends State<ComposeTweetSuggestions> {
  bool _showSuggestions = false;
  String _lastQuery;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() async {
      final String text = widget.controller.value.text;
      final TextSelection selection = widget.controller.selection;

      if (text.isNotEmpty &&
          selection.baseOffset >= 0 &&
          selection.baseOffset == selection.extentOffset) {
        // todo: when selection is inside a word, substring to next space
        final List<String> content =
            text.substring(0, selection.baseOffset).split(' ');

        final String last = content.last;

        if (last.startsWith(widget.identifier)) {
          // only start searching for suggestions when no change has been made
          // after some time
          await Future<void>.delayed(const Duration(milliseconds: 500));

          if (widget.controller.value.text == text) {
            _changeShowSuggestions(true);

            final String query = last.replaceAll(widget.identifier, '');

            if (query.isNotEmpty && query != _lastQuery) {
              widget.onSearch(query);
              _lastQuery = query;
            }
          }
        } else {
          _changeShowSuggestions(false);
        }
      } else {
        _changeShowSuggestions(false);
      }
    });
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
