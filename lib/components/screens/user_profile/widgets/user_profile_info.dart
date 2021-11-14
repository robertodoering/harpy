import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final relationshipBloc = context.watch<UserRelationshipBloc>();
    final relationshipState = relationshipBloc.state;

    // hide follow button when the profile of the authenticated user is showing
    // or when the connections have not been requested to determine whether the
    // authenticated user is following this user.
    final enableFollow =
        authCubit.state.user?.id != user.id && relationshipState.hasData;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(user: user),
        horizontalSpacer,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Handle(user: user),
              smallVerticalSpacer,
              _Name(user: user),
            ],
          ),
        ),
        if (enableFollow) ...[_FollowButton(user: user)],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => app<HarpyNavigator>().push(
        HeroDialogRoute<void>(
          onBackgroundTap: app<HarpyNavigator>().maybePop,
          builder: (_) => CustomDismissible(
            onDismissed: app<HarpyNavigator>().maybePop,
            child: HarpyMediaGallery.builder(
              itemCount: 1,
              heroTagBuilder: (_) => user.originalUserImageUrl,
              beginBorderRadiusBuilder: (_) => BorderRadius.circular(48),
              builder: (_, __) => HarpyImage(
                imageUrl: user.originalUserImageUrl,
              ),
            ),
          ),
        ),
      ),
      child: HarpyCircleAvatar(
        imageUrl: user.originalUserImageUrl,
        radius: 36,
        heroTag: user.originalUserImageUrl,
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final handle = '@${user.handle}';

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.lightImpact();
        Clipboard.setData(ClipboardData(text: handle));
        app<MessageService>().show('copied $handle');
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(handle, style: theme.textTheme.subtitle1),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: user.name),
          if (user.verified) ...[
            const TextSpan(text: ' '),
            const WidgetSpan(
              child: Icon(CupertinoIcons.checkmark_seal_fill, size: 22),
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.baseline,
            ),
          ],
        ],
        style: theme.textTheme.headline6,
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.user,
  });

  final UserData user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.watch<UserRelationshipBloc>();
    final state = bloc.state;

    return FadeAnimation(
      child: CustomAnimatedCrossFade(
        duration: kShortAnimationDuration,
        firstChild: HarpyButton.raised(
          text: const Text('following'),
          backgroundColor: theme.colorScheme.primary,
          dense: true,
          onTap: () {
            HapticFeedback.lightImpact();
            bloc.add(const UserRelationshipEvent.unfollow());
          },
        ),
        secondChild: HarpyButton.raised(
          text: const Text('follow'),
          dense: true,
          onTap: () {
            HapticFeedback.lightImpact();
            bloc.add(const UserRelationshipEvent.follow());
          },
        ),
        crossFadeState: state.following
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }
}
