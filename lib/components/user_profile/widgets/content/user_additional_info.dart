import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_bloc.dart';
import 'package:harpy/misc/url_launcher.dart';
import 'package:intl/intl.dart';

/// Builds additional info about a user for the [UserProfileHeader].
class UserProfileAdditionalInfo extends StatelessWidget {
  UserProfileAdditionalInfo(this.bloc);

  final UserProfileBloc bloc;

  final DateFormat _createdAtFormat = DateFormat('MMMM yyyy');

  Widget _buildRow(
    ThemeData theme,
    IconData icon, {
    String text,
    Widget child,
  }) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: text != null
              ? Text(
                  text,
                  style: theme.textTheme.bodyText1,
                )
              : child,
        ),
      ],
    );
  }

  Widget _buildUrl(ThemeData theme) {
    final Url url = bloc.user.entities.url.urls.first;

    final Widget child = GestureDetector(
      onTap: () => launchUrl(url.expandedUrl),
      child: Text(
        url.displayUrl,
        style: theme.textTheme.bodyText1.copyWith(
          color: theme.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return _buildRow(theme, Icons.link, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> content = <Widget>[
      if (bloc.user.hasLocation)
        _buildRow(theme, Icons.place, text: bloc.user.location),
      if (bloc.user.hasCreatedAt)
        _buildRow(
          theme,
          Icons.date_range,
          text: 'joined ${_createdAtFormat.format(bloc.user.createdAt)}',
        ),
      if (bloc.user.hasUrl) _buildUrl(theme),
    ];

    return Column(
      children: <Widget>[
        for (int i = 0; i < content.length; i++) ...<Widget>[
          content[i],
          // add a padding of 4 inbetween the content and 8 at the bottom
          if (i != content.length - 1)
            const SizedBox(height: 4)
          else
            const SizedBox(height: 8),
        ],
      ],
    );
  }
}
