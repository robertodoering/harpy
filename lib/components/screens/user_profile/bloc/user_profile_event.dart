part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {
  const UserProfileEvent();

  Future<void> handle(UserProfileBloc bloc, Emitter emit);
}

/// Initializes the data for the [UserProfileBloc.user].
///
/// Either [user] or [userHandle] must not be `null`.
///
/// If [user] is `null`, requests the user data for the [userHandle] and the
/// relationship status (following / followed_by).
///
/// Otherwise if the [UserData.connections] is `null`, only requests the
/// relationship status (connections).
///
/// Yields a [InitializedUserState] if [user] is not `null`, or when a user
/// object was able to be requested, regardless of the relationship status
/// request.
///
/// Yields a [FailedLoadingUserState] otherwise.
class InitializeUserEvent extends UserProfileEvent with HarpyLogger {
  const InitializeUserEvent({
    this.user,
    this.userHandle,
  }) : assert(user != null || userHandle != null);

  final UserData? user;

  final String? userHandle;

  /// The user id used to request the user or the relationship status.
  String? get _userHandle => userHandle ?? user?.handle;

  @override
  Future<void> handle(UserProfileBloc bloc, Emitter emit) async {
    log.fine('initialize user');

    emit(LoadingUserState());

    var userData = user;
    var connections = user?.connections;

    if (user?.connections == null) {
      await Future.wait([
        // user data
        if (userData == null && _userHandle != null)
          app<TwitterApi>()
              .userService
              .usersShow(screenName: _userHandle)
              .then((user) => UserData.fromUser(user))
              .then((user) => userData = user)
              .handleError(silentErrorHandler),

        // friendship lookup for the relationship status (following /
        // followed_by)
        if (connections == null && _userHandle != null)
          app<TwitterApi>()
              .userService
              .friendshipsLookup(screenNames: [_userHandle!])
              .then((response) => response.length == 1 ? response.first : null)
              .then<void>((friendship) => connections = friendship?.connections)
              .catchError(silentErrorHandler),
      ]);
    }

    if (userData == null) {
      emit(FailedLoadingUserState());
    } else {
      bloc.user = userData!.copyWith(
        connections: connections,
        userDescriptionEntities: userDescriptionEntities(
          userData!.userDescriptionUrls,
          userData!.description,
        ),
      );

      emit(InitializedUserState());
    }
  }
}

class FollowUserEvent extends UserProfileEvent with HarpyLogger {
  const FollowUserEvent();

  @override
  Future<void> handle(UserProfileBloc bloc, Emitter emit) async {
    log.fine('following @${bloc.user!.handle}');

    bloc.user!.connections?.add('following');
    emit(InitializedUserState());

    try {
      await app<TwitterApi>()
          .userService
          .friendshipsCreate(userId: bloc.user!.id);
      log.fine('successfully followed @${bloc.user!.handle}');
    } catch (e) {
      twitterApiErrorHandler(e);

      // assume still not following
      bloc.user!.connections?.remove('following');
      emit(InitializedUserState());
    }
  }
}

class UnfollowUserEvent extends UserProfileEvent with HarpyLogger {
  const UnfollowUserEvent();

  @override
  Future<void> handle(UserProfileBloc bloc, Emitter emit) async {
    log.fine('unfollowing @${bloc.user!.handle}');

    bloc.user!.connections?.remove('following');
    emit(InitializedUserState());

    try {
      await app<TwitterApi>()
          .userService
          .friendshipsDestroy(userId: bloc.user!.id);
      log.fine('successfully unfollowed @${bloc.user!.handle}');
    } catch (e) {
      twitterApiErrorHandler(e);

      // assume still following
      bloc.user!.connections?.add('following');
      emit(InitializedUserState());
    }
  }
}

/// Translates the user description.
///
/// The translation is saved in the [UserData.descriptionTranslation].
class TranslateUserDescriptionEvent extends UserProfileEvent {
  const TranslateUserDescriptionEvent({
    required this.locale,
  });

  final Locale locale;

  @override
  Future<void> handle(UserProfileBloc bloc, Emitter emit) async {
    unawaited(HapticFeedback.lightImpact());

    final translationService = app<TranslationService>();

    final translateLanguage =
        app<LanguagePreferences>().activeTranslateLanguage(locale.languageCode);

    emit(TranslatingDescriptionState());

    await translationService
        .translate(text: bloc.user!.description, to: translateLanguage)
        .then(
          (translation) => bloc.user = bloc.user!.copyWith(
            descriptionTranslation: translation,
          ),
        )
        .handleError(silentErrorHandler);

    if (!bloc.user!.hasDescriptionTranslation ||
        bloc.user!.descriptionTranslation!.unchanged) {
      app<MessageService>().show('description not translated');
    }

    emit(InitializedUserState());
  }
}
