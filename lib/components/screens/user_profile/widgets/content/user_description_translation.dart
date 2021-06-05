import 'package:flutter/material.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds the translated description for a user in the [UserProfileHeader].
class UserProfileDescriptionTranslation extends StatelessWidget {
  const UserProfileDescriptionTranslation(this.bloc);

  final UserProfileBloc bloc;

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedSize(
      child: AnimatedOpacity(
        opacity: bloc.user!.hasDescriptionTranslation ? 1 : 0,
        duration: kShortAnimationDuration,
        curve: Curves.easeOut,
        child: bloc.user!.hasDescriptionTranslation &&
                !bloc.user!.descriptionTranslation!.unchanged
            ? Padding(
                padding: EdgeInsets.only(top: defaultSmallPaddingValue),
                child: TranslatedText(
                  bloc.user!.descriptionTranslation!.text!,
                  language: bloc.user!.descriptionTranslation!.language,
                  entities: bloc.user!.userDescriptionEntities,
                ),
              )
            : const SizedBox(width: double.infinity),
      ),
    );
  }
}
