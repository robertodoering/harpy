import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class UserDescriptionTranslation extends ConsumerWidget {
  const UserDescriptionTranslation({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedSize(
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: user.descriptionTranslation != null ? 1 : 0,
        duration: kShortAnimationDuration,
        curve: Curves.easeOut,
        child: user.descriptionTranslation != null &&
                user.descriptionTranslation!.isTranslated
            ? Padding(
                padding: EdgeInsets.only(top: display.smallPaddingValue),
                child: TranslatedText(
                  user.descriptionTranslation!.text,
                  language: user.descriptionTranslation!.language,
                  entities: user.userDescriptionEntities,
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class UserDescriptionTranslationButton extends ConsumerWidget {
  const UserDescriptionTranslationButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconTheme = IconTheme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    // final active =
    //     user.descriptionTranslation != null || state.isTranslatingDescription;

    return TweetActionButton(
      active: false,
      iconBuilder: (_) => const Icon(Icons.translate),
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
      iconSize: iconTheme.size!,
      activeColor: harpyTheme.colors.translate,
      // ignore: unnecessary_lambdas
      activate: () {
        // TODO: translate
        HapticFeedback.lightImpact();
      },
      deactivate: null,
    );
  }
}
