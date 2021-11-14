import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class TranslationButton extends StatelessWidget {
  const TranslationButton({
    required this.active,
    required this.activate,
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 22,
  });

  final bool active;
  final VoidCallback activate;
  final EdgeInsets padding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final harpyTheme = context.watch<HarpyTheme>();

    return ActionButton(
      active: active,
      activate: activate,
      padding: padding,
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Colors.teal,
        dotSecondaryColor: Colors.tealAccent,
        dotThirdColor: Colors.lightBlue,
        dotLastColor: Colors.indigoAccent,
      ),
      circleColor: const CircleColor(
        start: Colors.tealAccent,
        end: Colors.lightBlueAccent,
      ),
      iconSize: iconSize,
      iconBuilder: (_, active, size) => Icon(
        Icons.translate,
        size: size,
        color: active ? harpyTheme.translateColor : null,
      ),
    );
  }
}

/// The translation button for the [TweetCardActionsRow].
class TweetTranslationButton extends StatelessWidget {
  const TweetTranslationButton({
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 22,
    this.sizeDelta = 0,
  });

  final EdgeInsets padding;
  final double iconSize;
  final double sizeDelta;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    final bloc = context.watch<TweetBloc>();

    return TranslationButton(
      active: bloc.state.translated || bloc.state.isTranslating,
      padding: padding,
      iconSize: iconSize + sizeDelta,
      activate: () => bloc.onTranslate(locale),
    );
  }
}
