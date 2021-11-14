import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return SliverToBoxAdapter(
      child: Card(
        margin: config.edgeInsetsOnly(left: true, right: true, top: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacer,
            Padding(
              padding: config.edgeInsetsSymmetric(horizontal: true),
              child: UserProfileInfo(user: user),
            ),
            smallVerticalSpacer,
            if (user.hasDescription) ...[
              Padding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                child: TwitterText(
                  user.description!,
                  entities: user.userDescriptionEntities,
                ),
              ),
              Padding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                child: _DescriptionTranslation(user: user),
              ),
              smallVerticalSpacer,
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: config.edgeInsetsOnly(left: true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserProfileAdditionalInfo(user: user),
                        FollowersCount(user),
                        verticalSpacer,
                      ],
                    ),
                  ),
                ),
                if (user.hasDescription)
                  _DescriptionTranslationButton(user: user),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionTranslation extends StatelessWidget {
  const _DescriptionTranslation({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return AnimatedSize(
      duration: kShortAnimationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: user.hasDescriptionTranslation ? 1 : 0,
        duration: kShortAnimationDuration,
        curve: Curves.easeOut,
        child: user.hasDescriptionTranslation &&
                !user.descriptionTranslation!.unchanged
            ? Padding(
                padding: EdgeInsets.only(top: config.smallPaddingValue),
                child: TranslatedText(
                  user.descriptionTranslation!.text!,
                  language: user.descriptionTranslation!.language,
                  entities: user.userDescriptionEntities,
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}

class _DescriptionTranslationButton extends StatelessWidget {
  const _DescriptionTranslationButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final config = context.watch<ConfigCubit>().state;

    final cubit = context.watch<UserProfileCubit>();
    final state = cubit.state;

    final active =
        user.hasDescriptionTranslation || state.isTranslatingDescription;

    return TranslationButton(
      active: active,
      padding: config.edgeInsets,
      activate: () {
        HapticFeedback.lightImpact();
        cubit.translateDescription(locale: locale);
      },
    );
  }
}
