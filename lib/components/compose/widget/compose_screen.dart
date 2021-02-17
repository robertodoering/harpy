import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

import 'content/compose_reply_card.dart';
import 'content/compose_tweet_card.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({
    this.inReplyToStatus,
  });

  final TweetData inReplyToStatus;

  static const String route = 'compose_screen';

  Widget _buildComposeCardWithReply(MediaQueryData mediaQuery) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * .6,
          ),
          child: const ComposeTweetCard(),
        ),
        defaultVerticalSpacer,
        ComposeReplyCard(inReplyToStatus: inReplyToStatus),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    Widget child;

    if (inReplyToStatus != null) {
      child = _buildComposeCardWithReply(mediaQuery);
    } else {
      child = const ComposeTweetCard();
    }

    return BlocProvider<ComposeBloc>(
      create: (BuildContext context) => ComposeBloc(
        inReplyToStatus: inReplyToStatus,
      ),
      child: HarpyScaffold(
        title: 'compose tweet',
        buildSafeArea: true,
        body: Padding(
          padding: DefaultEdgeInsets.all(),
          child: child,
        ),
      ),
    );
  }
}
