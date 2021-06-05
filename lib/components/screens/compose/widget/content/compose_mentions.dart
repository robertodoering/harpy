import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Displays user mention suggestions after typing `@`.
// todo: should not show exact match in suggestions list
class ComposeTweetMentions extends StatelessWidget {
  const ComposeTweetMentions({
    required this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthenticationBloc.of(context);

    return BlocProvider<MentionSuggestionsBloc>(
      create: (context) => MentionSuggestionsBloc(
        authenticatedUser: authBloc.authenticatedUser!,
      ),
      child:
          MentionSuggestions(controller: controller as ComposeTextController?),
    );
  }
}

class MentionSuggestions extends StatelessWidget {
  const MentionSuggestions({
    required this.controller,
  });

  final ComposeTextController? controller;

  Widget _buildHeader(ThemeData theme, String text) {
    return Padding(
      padding: DefaultEdgeInsets.all().copyWith(
        bottom: defaultSmallPaddingValue / 2,
      ),
      child: Text(
        text,
        style: theme.textTheme.subtitle1!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUser(ThemeData theme, UserData user) {
    return HarpyButton.flat(
      padding: EdgeInsets.symmetric(
        vertical: defaultSmallPaddingValue / 2,
        horizontal: defaultPaddingValue,
      ),
      text: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(text: '${user.name}\n'),
            TextSpan(text: '@${user.handle}'),
          ],
        ),
        style: theme.textTheme.bodyText1!.copyWith(
          color: theme.accentColor,
        ),
      ),
      onTap: () => controller!.replaceSelection(
        '@${user.handle} ',
      ),
    );
  }

  Widget _buildFollowingUsers(ThemeData theme, MentionSuggestionsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildHeader(theme, 'following users'),
        for (UserData user in state.filteredFollowing) _buildUser(theme, user),
      ],
    );
  }

  Widget _buildSearchedUsers(ThemeData theme, MentionSuggestionsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildHeader(theme, 'other users'),
        for (UserData user in state.filteredSearchedUsers)
          _buildUser(theme, user),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.watch<MentionSuggestionsBloc>();
    final state = bloc.state;

    Widget? child;

    if (state.hasSuggestions || bloc.loadingSearchedUsers) {
      child = ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          if (state.filteredFollowing.isNotEmpty)
            _buildFollowingUsers(theme, state),
          if (state.filteredSearchedUsers.isNotEmpty)
            _buildSearchedUsers(theme, state),
        ],
      );
    }

    return ComposeTweetSuggestions(
      controller: controller,
      selectionRegExp: mentionStartRegex,
      onSearch: (query) => bloc.add(FindMentionsEvent(query)),
      child: child,
    );
  }
}
