import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:intl/intl.dart';

/// Builds additional info about a user for the [UserProfileHeader].
class UserProfileAdditionalInfo extends StatelessWidget {
  UserProfileAdditionalInfo(this.bloc);

  final UserProfileBloc bloc;

  final DateFormat _createdAtFormat = DateFormat('MMMM yyyy');

  Widget _buildRow(
    ThemeData theme,
    IconData icon, {
    String? text,
    Widget? child,
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
              : child!,
        ),
      ],
    );
  }

  Widget _buildUrl(BuildContext context, ThemeData theme) {
    final url = bloc.user!.userUrl!;

    final Widget child = GestureDetector(
      onTap: () => defaultOnUrlTap(context, url),
      onLongPress: () => defaultOnUrlLongPress(context, url),
      child: Text(
        url.displayUrl,
        style: theme.textTheme.bodyText1!.copyWith(
          color: theme.accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return _buildRow(theme, CupertinoIcons.link, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final children = <Widget>[
      if (bloc.user!.hasLocation)
        _buildRow(
          theme,
          CupertinoIcons.map_pin_ellipse,
          text: bloc.user!.location,
        ),
      if (bloc.user!.hasCreatedAt)
        _buildRow(
          theme,
          CupertinoIcons.calendar,
          text: 'joined ${_createdAtFormat.format(bloc.user!.createdAt!)}',
        ),
      if (bloc.user!.hasUrl) _buildUrl(context, theme),
      if (bloc.user!.follows)
        _buildRow(theme, CupertinoIcons.reply, text: 'follows you'),
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
