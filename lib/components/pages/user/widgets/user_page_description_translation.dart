import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class UserPageDescriptionTranslation extends StatelessWidget {
  const UserPageDescriptionTranslation({
    required this.data,
  });

  final UserPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final translation = data.descriptionTranslationState.maybeWhen(
      translated: (translation) => translation,
      orElse: () => null,
    );

    return AnimatedSize(
      duration: theme.animation.short,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: translation != null ? 1 : 0,
        duration: theme.animation.short,
        curve: Curves.easeOut,
        child: translation != null
            ? Padding(
                padding: EdgeInsetsDirectional.only(top: theme.spacing.small),
                child: TranslatedText(
                  translation.text,
                  language: translation.language,
                  entities: data.user.descriptionEntities,
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class UserPageDescriptionTranslationButton extends ConsumerWidget {
  const UserPageDescriptionTranslationButton({
    required this.data,
    required this.notifier,
  });

  final UserPageData data;
  final UserPageNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);

    final active = data.descriptionTranslationState.maybeMap(
      untranslated: (_) => false,
      orElse: () => true,
    );

    return TweetActionButton(
      active: active,
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
      iconSize: theme.iconTheme.size!,
      activeColor: harpyTheme.colors.translate,
      activate: () {
        HapticFeedback.lightImpact();
        notifier.translateDescription(locale: Localizations.localeOf(context));
      },
      deactivate: null,
    );
  }
}
