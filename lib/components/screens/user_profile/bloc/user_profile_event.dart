part of 'user_profile_bloc.dart';

@immutable
abstract class UserProfileEvent {
  const UserProfileEvent();

  Stream<UserProfileState> applyAsync({
    required UserProfileState currentState,
    required UserProfileBloc bloc,
  });
}

/// Initializes the data for the [UserProfileBloc.user].
///
/// Either [user] or [handle] must not be `null`.
///
/// If [user] is `null`, requests the user data for the [handle] and the
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
    this.handle,
  }) : assert(user != null || handle != null);

  final UserData? user;

  final String? handle;

  /// The user id used to request the user or the relationship status.
  String? get _handle => handle ?? user?.handle;

  @override
  Stream<UserProfileState> applyAsync({
    required UserProfileState currentState,
    required UserProfileBloc bloc,
  }) async* {
    log.fine('initialize user');

    yield LoadingUserState();

    var userData = user;
    var connections = user?.connections;

    if (user?.connections == null) {
      await Future.wait<void>(<Future<void>>[
        // user data
        if (userData == null && _handle != null)
          bloc.userService
              .usersShow(screenName: _handle)
              .then((user) => UserData.fromUser(user))
              .then((user) => userData = user)
              .handleError(silentErrorHandler),

        // friendship lookup for the relationship status (following /
        // followed_by)
        if (connections == null && _handle != null)
          bloc.userService
              .friendshipsLookup(screenNames: <String>[_handle!])
              .then((response) => response.length == 1 ? response.first : null)
              .then<void>((friendship) => connections = friendship?.connections)
              .catchError(silentErrorHandler),
      ]);
    }

    if (userData == null) {
      yield FailedLoadingUserState();
    } else {
      bloc.user = userData!.copyWith(
        connections: connections,
        userDescriptionEntities: userDescriptionEntities(
          userData!.userDescriptionUrls,
          userData!.description,
        ),
      );

      yield InitializedUserState();
    }
  }
}

class FollowUserEvent extends UserProfileEvent with HarpyLogger {
  const FollowUserEvent();

  @override
  Stream<UserProfileState> applyAsync({
    required UserProfileState currentState,
    required UserProfileBloc bloc,
  }) async* {
    log.fine('following @${bloc.user!.handle}');

    bloc.user!.connections?.add('following');
    yield InitializedUserState();

    try {
      await bloc.userService.friendshipsCreate(userId: bloc.user!.id);
      log.fine('successfully followed @${bloc.user!.handle}');
    } catch (e) {
      twitterApiErrorHandler(e);

      // assume still not following
      bloc.user!.connections?.remove('following');
      yield InitializedUserState();
    }
  }
}

class UnfollowUserEvent extends UserProfileEvent with HarpyLogger {
  const UnfollowUserEvent();

  @override
  Stream<UserProfileState> applyAsync({
    required UserProfileState currentState,
    required UserProfileBloc bloc,
  }) async* {
    log.fine('unfollowing @${bloc.user!.handle}');

    bloc.user!.connections?.remove('following');
    yield InitializedUserState();

    try {
      await bloc.userService.friendshipsDestroy(userId: bloc.user!.id);
      log.fine('successfully unfollowed @${bloc.user!.handle}');
    } catch (e) {
      twitterApiErrorHandler(e);

      // assume still following
      bloc.user!.connections?.add('following');
      yield InitializedUserState();
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
  Stream<UserProfileState> applyAsync({
    required UserProfileState currentState,
    required UserProfileBloc bloc,
  }) async* {
    unawaited(HapticFeedback.lightImpact());

    final translationService = app<TranslationService>();

    final translateLanguage =
        bloc.languagePreferences.activeTranslateLanguage(locale.languageCode);

    yield TranslatingDescriptionState();

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

    yield InitializedUserState();
  }
}
