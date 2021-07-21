import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/settings/theme_selection/bloc/theme_bloc.dart';
import 'package:harpy/core/core.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required this.themeBloc,
  }) : super(const Unauthenticated());

  final ThemeBloc themeBloc;

  Future<bool> initializeSession() async {
    if (hasTwitterConfig) {
      final twitterWebviewAuth = TwitterAuth(
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret,
      );

      // init active twitter session
      final token = app<AuthPreferences>().userToken;
      final secret = app<AuthPreferences>().userSecret;
      final userId = app<AuthPreferences>().userId;

      if (token.isNotEmpty && secret.isNotEmpty && userId.isNotEmpty) {
        final twitterAuthSession = TwitterAuthSession(
          token: token,
          tokenSecret: secret,
          userId: userId,
        );
      }
    }
  }
}

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated();

  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationState {
  const Authenticated({
    required this.twitterAuthSession,
    required this.authenticatedUser,
  });

  final TwitterAuthSession twitterAuthSession;
  final UserData authenticatedUser;

  @override
  List<Object?> get props => [
        twitterAuthSession,
        authenticatedUser,
      ];
}
