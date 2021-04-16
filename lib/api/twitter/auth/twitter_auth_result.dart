import 'package:flutter/foundation.dart';

enum TwitterAuthStatus {
  success,
  failure,
  userCancelled,
}

@immutable
class TwitterAuthResult {
  const TwitterAuthResult({
    @required this.status,
    this.session,
  }) : assert(status == TwitterAuthStatus.success && session != null ||
            status != TwitterAuthStatus.success);

  final TwitterAuthStatus status;
  final TwitterAuthSession session;

  @override
  String toString() {
    return 'TwitterAuthResult{'
        'status: $status, '
        'credentials: $session}';
  }
}

@immutable
class TwitterAuthSession {
  const TwitterAuthSession({
    @required this.token,
    @required this.tokenSecret,
    @required this.userId,
  });

  final String token;
  final String tokenSecret;
  final String userId;

  @override
  String toString() {
    return 'TwitterAuthSession{'
        'token: $token, '
        'tokenSecret: $tokenSecret, '
        'userId: $userId}';
  }
}
