import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/compose/bloc/compose/compose_bloc.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

import 'content/compose_tweet_card.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen();

  static const String route = 'compose_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComposeBloc>(
      create: (BuildContext context) => ComposeBloc(),
      child: HarpyScaffold(
        title: 'compose tweet',
        buildSafeArea: true,
        body: Padding(
          padding: DefaultEdgeInsets.all(),
          child: const ComposeTweetCard(),
        ),
      ),
    );
  }
}
