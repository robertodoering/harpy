import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/compose_state.dart';
import 'package:harpy/components/compose/widget/content/compose_action_row.dart';
import 'package:harpy/components/compose/widget/content/compose_media.dart';
import 'package:harpy/components/search/user/bloc/user_search_bloc.dart';
import 'package:harpy/components/search/user/bloc/user_search_event.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';
import 'package:harpy/core/api/twitter/user_data.dart';

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
        minLines: 4,
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
                            child: ComposeTweetSuggestions(
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

class ComposeTweetSuggestions extends StatelessWidget {
  const ComposeTweetSuggestions(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserSearchBloc>(
      create: (BuildContext context) => UserSearchBloc(),
      child: BlocBuilder<UserSearchBloc, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          return ComposeTweetMentions(
            bloc,
            userSearchBloc: UserSearchBloc.of(context),
            controller: controller,
          );
        },
      ),
    );
  }
}

// todo: this should build the abstract widget that listens to the controller
// with a specified prefix that will trigger a callback when the word starting
// with the prefix is selected
class ComposeTweetMentions extends StatefulWidget {
  const ComposeTweetMentions(
    this.bloc, {
    @required this.userSearchBloc,
    @required this.controller,
  });

  final ComposeBloc bloc;
  final UserSearchBloc userSearchBloc;
  final TextEditingController controller;

  @override
  _ComposeTweetMentionsState createState() => _ComposeTweetMentionsState();
}

class _ComposeTweetMentionsState extends State<ComposeTweetMentions> {
  bool _show = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() async {
      final String text = widget.controller.value.text;
      final TextSelection selection = widget.controller.selection;

      if (text.isNotEmpty &&
          selection.baseOffset >= 0 &&
          selection.baseOffset == selection.extentOffset) {
        // only start searching for suggestions when no change has been made
        // after a bit
        await Future<void>.delayed(const Duration(milliseconds: 500));

        if (widget.controller.value.text == text) {
          // todo: when selection is inside a word, substring to next space
          final List<String> content =
              text.substring(0, selection.baseOffset).split(' ');

          final String last = content.last;

          if (last.startsWith('@')) {
            _showUserList(true);
            // todo: when no name yet entered, search for following
            // todo: when name entered, filter following and start search for
            //   users
            final String query = last.replaceAll('@', '');
            if (query.isNotEmpty && widget.userSearchBloc.lastQuery != query) {
              widget.userSearchBloc.add(SearchUsers(query));
            }
          } else {
            _showUserList(false);
          }
        }
      } else {
        _showUserList(false);
      }
    });
  }

  void _showUserList(bool show) {
    if (_show != show) {
      setState(() {
        _show = show;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double maxHeight = mediaQuery.size.height / 2;

    Widget child;

    if (_show && widget.userSearchBloc.hasData) {
      child = Card(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: ListView(
            padding: EdgeInsets.all(defaultSmallPaddingValue),
            shrinkWrap: true,
            children: widget.userSearchBloc.users
                .map((UserData user) => Text(user.screenName))
                .toList(),
          ),
        ),
      );
    } else {
      child = const SizedBox();
    }

    return CustomAnimatedSize(
      child: AnimatedSwitcher(
        duration: kShortAnimationDuration,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
    );
  }
}
