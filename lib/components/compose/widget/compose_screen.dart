import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_state.dart';
import 'package:harpy/components/compose/widget/content/compose_action_row.dart';
import 'package:harpy/components/compose/widget/content/compose_media.dart';
import 'package:harpy/components/compose/widget/content/compose_mentions.dart';
import 'package:harpy/components/compose/widget/content/compose_trends.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen();

  static const String route = 'compose_screen';

  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  Widget _buildTextField(ThemeData theme) {
    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        style: theme.textTheme.bodyText1,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "What's happening?",
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMedia(ComposeBloc bloc) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: bloc.hasMedia ? ComposeTweetMedia(bloc) : const SizedBox(),
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

          // todo: focus text field when card is tapped

          return HarpyScaffold(
            title: 'Compose Tweet',
            body: Padding(
              padding: DefaultEdgeInsets.all(),
              child: Card(
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
                          _buildTextField(theme),
                          Padding(
                            padding: DefaultEdgeInsets.all(),
                            child: ComposeTweetMentions(
                              bloc,
                              controller: _controller,
                            ),
                          ),
                          Padding(
                            padding: DefaultEdgeInsets.all(),
                            child: ComposeTweetTrends(
                              bloc,
                              controller: _controller,
                            ),
                          ),
                          _buildMedia(bloc),
                        ],
                      ),
                    ),
                    ComposeTweetActionRow(bloc, controller: _controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
