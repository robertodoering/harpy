import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/compose/bloc/compose_bloc.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_bloc.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_event.dart';
import 'package:harpy/components/compose/bloc/mention_suggestions/mention_suggestions_state.dart';
import 'package:harpy/components/compose/widget/compose_text_controller.dart';
import 'package:harpy/components/compose/widget/content/compose_suggestions.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/regex/twitter_regex.dart';

/// Displays user mention suggestions after typing `@`.
class ComposeTweetMentions extends StatelessWidget {
  const ComposeTweetMentions(
    this.bloc, {
    @required this.controller,
  });

  final ComposeBloc bloc;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);

    return BlocProvider<MentionSuggestionsBloc>(
      create: (BuildContext context) => MentionSuggestionsBloc(
        authenticatedUser: authBloc.authenticatedUser,
      ),
      child: BlocBuilder<MentionSuggestionsBloc, MentionSuggestionsState>(
        builder: (BuildContext context, MentionSuggestionsState state) {
          final MentionSuggestionsBloc suggestionsBloc =
              MentionSuggestionsBloc.of(context);

          Widget child;

          if (suggestionsBloc.hasUserSuggestions ||
              suggestionsBloc.loadingSearchedUsers) {
            child = MentionSuggestions(
              suggestionsBloc,
              controller: controller,
            );
          }

          return ComposeTweetSuggestions(
            bloc,
            controller: controller,
            selectionRegExp: mentionStartRegex,
            onSearch: (String query) {
              suggestionsBloc.add(FindMentionsEvent(query));
            },
            child: child,
          );
        },
      ),
    );
  }
}

class MentionSuggestions extends StatelessWidget {
  const MentionSuggestions(
    this.suggestionsBloc, {
    @required this.controller,
  });

  final MentionSuggestionsBloc suggestionsBloc;
  final ComposeTextController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: <Widget>[
        if (suggestionsBloc.followingUsers.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: DefaultEdgeInsets.all()
                    .copyWith(bottom: defaultSmallPaddingValue / 2),
                child: Text(
                  'Following users',
                  style: theme.textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (UserData user in suggestionsBloc.followingUsers)
                HarpyButton.flat(
                  padding: EdgeInsets.symmetric(
                    vertical: defaultSmallPaddingValue / 2,
                    horizontal: defaultPaddingValue,
                  ),
                  text: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: '${user.name}\n'),
                        TextSpan(text: '@${user.screenName}'),
                      ],
                    ),
                    style: theme.textTheme.bodyText1.copyWith(
                      color: theme.accentColor,
                    ),
                  ),
                  onTap: () => controller.replaceSelection(
                    '@${user.screenName} ',
                  ),
                ),
            ],
          ),
        if (suggestionsBloc.suggestedUsers.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: DefaultEdgeInsets.all()
                    .copyWith(bottom: defaultSmallPaddingValue / 2),
                child: Text(
                  'Other users',
                  style: theme.textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (UserData user in suggestionsBloc.suggestedUsers)
                HarpyButton.flat(
                  padding: EdgeInsets.symmetric(
                    vertical: defaultSmallPaddingValue / 2,
                    horizontal: defaultPaddingValue,
                  ),
                  text: Text(
                    '${user.name}\n'
                    '@${user.screenName}',
                    style: theme.textTheme.bodyText1.copyWith(
                      color: theme.accentColor,
                    ),
                  ),
                  onTap: () => controller.replaceSelection(
                    '@${user.screenName} ',
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
