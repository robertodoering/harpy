import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_state.dart';
import 'package:harpy/components/compose/widget/compose_text_cotroller.dart';
import 'package:harpy/components/compose/widget/content/compose_action_row.dart';
import 'package:harpy/components/compose/widget/content/compose_media.dart';
import 'package:harpy/components/compose/widget/content/compose_mentions.dart';
import 'package:harpy/components/compose/widget/content/compose_text_field.dart';
import 'package:harpy/components/compose/widget/content/compose_trends.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/core/regex/twitter_regex.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen();

  static const String route = 'compose_screen';

  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  ComposeTextController _controller;
  FocusNode _focusNode;
  int _keyboardListenerId;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _keyboardListenerId = KeyboardVisibilityNotification().addNewListener(
      onHide: _focusNode.unfocus,
    );
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

    KeyboardVisibilityNotification().removeListener(_keyboardListenerId);

    _controller.dispose();
    _focusNode.dispose();
  }

  Widget _buildMedia(ComposeBloc bloc) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: bloc.hasMedia ? ComposeTweetMedia(bloc) : const SizedBox(),
    );
  }

  Widget _buildCard(
    AuthenticationBloc authBloc,
    ThemeData theme,
    ComposeBloc bloc,
  ) {
    return Card(
      elevation: 0,
      child: Column(
        children: <Widget>[
          Expanded(
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
                ComposeTweetMentions(bloc, controller: _controller),
                ComposeTweetTrends(bloc, controller: _controller),
                _buildMedia(bloc),
              ],
            ),
          ),
          ComposeTweetActionRow(bloc, controller: _controller),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);

    return BlocProvider<ComposeBloc>(
      create: (BuildContext context) => ComposeBloc(),
      child: BlocBuilder<ComposeBloc, ComposeState>(
        builder: (BuildContext context, ComposeState state) {
          final ComposeBloc bloc = ComposeBloc.of(context);

          return HarpyScaffold(
            title: 'Compose Tweet',
            body: Padding(
              padding: DefaultEdgeInsets.all(),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(_focusNode),
                child: _buildCard(authBloc, theme, bloc),
              ),
            ),
          );
        },
      ),
    );
  }
}
