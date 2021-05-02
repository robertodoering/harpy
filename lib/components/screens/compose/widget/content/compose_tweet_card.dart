import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class ComposeTweetCard extends StatefulWidget {
  const ComposeTweetCard();

  @override
  _ComposeTweetCardState createState() => _ComposeTweetCardState();
}

class _ComposeTweetCardState extends State<ComposeTweetCard> {
  ComposeTextController _controller;
  FocusNode _focusNode;
  StreamSubscription<bool> _keyboardListener;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _keyboardListener = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= ComposeTextController(
      textStyleMap: <RegExp, TextStyle>{
        hashtagRegex: TextStyle(color: Theme.of(context).accentColor),
        mentionRegex: TextStyle(color: Theme.of(context).accentColor),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _keyboardListener.cancel();
    _controller.dispose();
    _focusNode.dispose();
  }

  Widget _buildMedia(ComposeState state) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: state.hasMedia ? const ComposeTweetMedia() : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);
    final ComposeBloc bloc = context.watch<ComposeBloc>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Card(
        elevation: 0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Padding(
                      padding: DefaultEdgeInsets.all(),
                      child: TweetAuthorRow(
                        authBloc.authenticatedUser,
                        enableUserTap: false,
                      ),
                    ),
                    ComposeTextField(
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                    ComposeTweetMentions(controller: _controller),
                    ComposeTweetTrends(controller: _controller),
                    _buildMedia(bloc.state),
                  ],
                ),
              ),
            ),
            ComposeTweetActionRow(controller: _controller),
          ],
        ),
      ),
    );
  }
}
