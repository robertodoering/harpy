import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
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
        Icon(icon, size: 16),
        defaultHorizontalSpacer,
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

    return _buildRow(theme, FeatherIcons.link2, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> children = <Widget>[
      if (bloc.user.hasLocation)
        _buildRow(theme, FeatherIcons.mapPin, text: bloc.user.location),
      if (bloc.user.hasCreatedAt)
        _buildRow(
          theme,
          FeatherIcons.calendar,
          text: 'joined ${_createdAtFormat.format(bloc.user.createdAt)}',
        ),
      if (bloc.user.hasUrl) _buildUrl(theme),
    ];

    return Column(
      children: <Widget>[
        for (Widget child in children) ...<Widget>[
          child,
          if (child == children.last)
            defaultSmallVerticalSpacer
          else
            SizedBox(height: defaultSmallPaddingValue / 2),
        ],
      ],
    );
  }
}
