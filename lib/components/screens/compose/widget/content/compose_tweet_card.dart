import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class ComposeTweetCard extends StatefulWidget {
  const ComposeTweetCard();

  @override
  _ComposeTweetCardState createState() => _ComposeTweetCardState();
}

class _ComposeTweetCardState extends State<ComposeTweetCard>
    with AutomaticKeepAliveClientMixin {
  late final FocusNode _focusNode;
  late final StreamSubscription<bool> _keyboardListener;
  ComposeTextController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _keyboardListener = KeyboardVisibilityController().onChange.listen((
      visible,
    ) {
      if (!visible) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    _controller ??= ComposeTextController(
      textStyleMap: {
        hashtagRegex: TextStyle(color: theme.colorScheme.secondary),
        mentionRegex: TextStyle(color: theme.colorScheme.secondary),
      },
    );
  }

  @override
  void dispose() {
    _keyboardListener.cancel();
    _controller?.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  Widget _buildMedia(ComposeState state) {
    return AnimatedSwitcher(
      duration: kShortAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: state.hasMedia ? const ComposeTweetMedia() : const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bloc = context.watch<ComposeBloc>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const _TopRow(),
                    const _DisabledMentions(),
                    ComposeTextField(
                      controller: _controller!,
                      focusNode: _focusNode,
                    ),
                    _buildMedia(bloc.state),
                  ],
                ),
              ),
            ),
            ComposeTweetActionRow(controller: _controller!),
          ],
        ),
      ),
    );
  }
}

class _DisabledMentions extends StatelessWidget {
  const _DisabledMentions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsets.copyWith(top: 0),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: theme.primaryColor),
          horizontalSpacer,
          Expanded(
            child: Text(
              '@mentions are currently disabled',
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.primaryColor.withOpacity(.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();

    return BlocProvider<TweetBloc>(
      create: (_) => PreviewTweetBloc(
        TweetData(
          user: authCubit.state.user!,
          createdAt: DateTime.now(),
        ),
      ),
      child: TweetCardTopRow(
        innerPadding: config.smallPaddingValue,
        outerPadding: config.paddingValue,
        config: const TweetCardConfig(
          elements: [
            TweetCardElement.avatar,
            TweetCardElement.name,
            TweetCardElement.handle,
          ],
        ),
      ),
    );
  }
}
