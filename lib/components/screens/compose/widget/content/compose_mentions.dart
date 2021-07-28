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

  final ComposeTextController? controller;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();

    return BlocProvider<MentionSuggestionsBloc>(
      create: (context) => MentionSuggestionsBloc(
        authenticatedUser: authCubit.state.user!,
      ),
      child: MentionSuggestions(controller: controller),
    );
  }
}

class MentionSuggestions extends StatelessWidget {
  const MentionSuggestions({
    required this.controller,
  });

  final ComposeTextController? controller;

  Widget _buildHeader(Config config, ThemeData theme, String text) {
    return Padding(
      padding: config.edgeInsets.copyWith(
        bottom: config.smallPaddingValue / 2,
      ),
      child: Text(
        text,
        style: theme.textTheme.subtitle1!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUser(Config config, ThemeData theme, UserData user) {
    return HarpyButton.flat(
      padding: EdgeInsets.symmetric(
        vertical: config.smallPaddingValue / 2,
        horizontal: config.paddingValue,
      ),
      text: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(text: '${user.name}\n'),
            TextSpan(text: '@${user.handle}'),
          ],
        ),
        style: theme.textTheme.bodyText1!.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      onTap: () => controller!.replaceSelection(
        '@${user.handle} ',
      ),
    );
  }

  Widget _buildFollowingUsers(
    Config config,
    ThemeData theme,
    MentionSuggestionsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(config, theme, 'following users'),
        for (UserData user in state.filteredFollowing)
          _buildUser(config, theme, user),
      ],
    );
  }

  Widget _buildSearchedUsers(
    Config config,
    ThemeData theme,
    MentionSuggestionsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(config, theme, 'other users'),
        for (UserData user in state.filteredSearchedUsers)
          _buildUser(config, theme, user),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<MentionSuggestionsBloc>();
    final state = bloc.state;

    Widget? child;

    if (state.hasSuggestions || bloc.loadingSearchedUsers) {
      child = ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          if (state.filteredFollowing.isNotEmpty)
            _buildFollowingUsers(config, theme, state),
          if (state.filteredSearchedUsers.isNotEmpty)
            _buildSearchedUsers(config, theme, state),
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
