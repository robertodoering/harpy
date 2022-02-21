import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class Replybutton extends ConsumerWidget {
  const Replybutton({
    required this.tweet,
    required this.onComposeReply,
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final TweetActionCallback? onComposeReply;
  final double sizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => Icon(CupertinoIcons.reply, size: iconSize),
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activeColor: harpyTheme.colors.favorite,
      activate: () => onComposeReply?.call(context, ref.read),
      deactivate: null,
    );
  }
}
