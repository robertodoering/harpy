import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

class TranslateButton extends ConsumerWidget {
  const TranslateButton({
    required this.tweet,
    required this.onTranslate,
    this.sizeDelta = 0,
  });

  final TweetData tweet;
  final TweetActionCallback? onTranslate;
  final double sizeDelta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final iconSize = iconTheme.size! + sizeDelta;

    return TweetActionButton(
      active: tweet.translation != null ||
          tweet.isTranslating ||
          tweet.quote?.translation != null ||
          (tweet.quote?.isTranslating ?? false),
      iconBuilder: (_) => Icon(Icons.translate, size: iconSize),
      bubblesColor: const BubblesColor(
        primary: Colors.teal,
        secondary: Colors.tealAccent,
        tertiary: Colors.lightBlue,
        quaternary: Colors.indigoAccent,
      ),
      circleColor: const CircleColor(
        start: Colors.tealAccent,
        end: Colors.lightBlueAccent,
      ),
      iconSize: iconSize,
      sizeDelta: sizeDelta,
      activeColor: harpyTheme.colors.translate,
      activate: () => onTranslate?.call(context, ref.read),
      deactivate: null,
    );
  }
}
