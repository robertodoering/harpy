import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class RetweetersPage extends ConsumerWidget {
  const RetweetersPage({
    required this.tweetId,
  });

  final String tweetId;

  static const name = 'retweeters';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(retweetersProvider(tweetId));

    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: LegacyUserList(
            state.whenOrNull(data: (users) => users.toList()) ?? [],
            beginSlivers: const [
              HarpySliverAppBar(title: Text('retweeted by')),
            ],
            endSlivers: [
              ...?state.whenOrNull(
                loading: () => [const UserListLoadingSliver()],
                data: (users) => [
                  if (users.isEmpty)
                    const SliverFillInfoMessage(
                      secondaryMessage: Text('no retweeters'),
                    ),
                ],
                error: (_, __) => const [
                  SliverFillLoadingError(
                    message: Text('error loading retweeters'),
                  ),
                ],
              ),
              const SliverBottomPadding(),
            ],
          ),
        ),
      ),
    );
  }
}
