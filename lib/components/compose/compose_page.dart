import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class ComposePage extends ConsumerStatefulWidget {
  const ComposePage({
    this.parentTweet,
    this.quotedTweet,
  }) : assert(parentTweet == null || quotedTweet == null);

  /// The tweet that the user is replying to.
  final TweetData? parentTweet;

  /// The tweet that the user is quoting (aka retweeting with quote).
  final TweetData? quotedTweet;

  static const name = 'compose';

  @override
  ConsumerState<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends ConsumerState<ComposePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(composeProvider.notifier).initialize(
            parentTweet: widget.parentTweet,
            quotedTweet: widget.quotedTweet,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('compose')),
          SliverPadding(
            padding: display.edgeInsets,
            sliver: SliverToBoxAdapter(
              child: widget.parentTweet != null || widget.quotedTweet != null
                  ? ComposeTweetCardWithParent(
                      parentTweet: widget.parentTweet,
                      quotedTweet: widget.quotedTweet,
                    )
                  : const ComposeTweetCard(),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}
