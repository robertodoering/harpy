import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class ComposeTweetCard extends ConsumerStatefulWidget {
  const ComposeTweetCard();

  @override
  ConsumerState<ComposeTweetCard> createState() => _ComposeTweetCardState();
}

class _ComposeTweetCardState extends ConsumerState<ComposeTweetCard>
    with AutomaticKeepAliveClientMixin {
  final FocusNode _focusNode = FocusNode();
  late final StreamSubscription<bool> _keyboardListener;

  ComposeTextController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _keyboardListener = KeyboardVisibilityController().onChange.listen((
      visible,
    ) {
      if (!visible) _focusNode.unfocus();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final state = ref.watch(composeProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            const _TopRow(),
            ComposeTextField(
              controller: _controller!,
              focusNode: _focusNode,
            ),
            RbyAnimatedSwitcher(
              reverseDuration: Duration.zero,
              child: state.hasMedia ? const ComposeMedia() : const SizedBox(),
            ),
            ComposeTweetActions(
              controller: _controller!,
              focusNode: _focusNode,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRow extends ConsumerWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authentication = ref.watch(authenticationStateProvider);

    return TweetCardTopRow(
      tweet: LegacyTweetData(
        createdAt: DateTime.now(),
        user: authentication.user!,
      ),
      delegates: const TweetDelegates(),
      innerPadding: theme.spacing.small,
      outerPadding: theme.spacing.base,
      config: const TweetCardConfig(
        elements: {
          TweetCardElement.avatar,
          TweetCardElement.name,
          TweetCardElement.handle,
        },
      ),
    );
  }
}
