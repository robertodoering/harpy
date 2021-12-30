import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'user_profile_cubit.freezed.dart';

/// Handles loading the user and actions on the user.
///
/// The user data is only requested if no [_initialUser] is provided.
class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({
    UserData? initialUser,
    String? handle,
  })  : assert(
          initialUser != null || handle != null,
          'no initial user or handle specified',
        ),
        _handle = handle ?? initialUser!.handle,
        _initialUser = initialUser,
        super(
          initialUser == null
              ? const UserProfileState.loading()
              : UserProfileState.data(user: initialUser),
        ) {
    requestUserData();
  }

  final UserData? _initialUser;
  final String _handle;

  Future<void> requestUserData() async {
    if (_initialUser == null) {
      emit(const UserProfileState.loading());

      final user = await app<TwitterApi>()
          .userService
          .usersShow(screenName: _handle)
          .then(UserData.fromUser)
          .handleError(silentErrorHandler);

      if (user != null) {
        emit(UserProfileState.data(user: user));
      } else {
        emit(const UserProfileState.error());
      }
    }
  }

  Future<void> translateDescription({
    required Locale locale,
  }) async {
    final initialState = state;

    if (initialState is _Data) {
      final translateLanguage =
          app<LanguagePreferences>().activeTranslateLanguage(
        locale.languageCode,
      );

      emit(initialState.copyWith(isTranslatingDescription: true));

      final translation = await app<TranslationService>()
          .translate(text: initialState.user.description, to: translateLanguage)
          .handleError(silentErrorHandler);

      final user = initialState.user.copyWith(
        descriptionTranslation: translation,
      );

      if (!user.hasDescriptionTranslation ||
          user.descriptionTranslation!.unchanged) {
        app<MessageService>().show('description not translated');
      }

      emit(initialState.copyWith(user: user, isTranslatingDescription: false));
    }
  }
}

@freezed
class UserProfileState with _$UserProfileState {
  const factory UserProfileState.loading() = _Loading;

  const factory UserProfileState.data({
    required UserData user,
    @Default(false) bool isTranslatingDescription,
  }) = _Data;

  const factory UserProfileState.error() = _Error;
}

extension UserProfileStateExtension on UserProfileState {
  bool get isTranslatingDescription => maybeMap(
        data: (value) => value.isTranslatingDescription,
        orElse: () => false,
      );
}
