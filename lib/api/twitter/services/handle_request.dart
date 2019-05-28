import 'dart:async';

import 'package:http/http.dart';
import 'package:logging/logging.dart';

Logger _log = Logger("HandleResponse");

typedef T OnSuccess<T>(Response response);

/// Used when an error occurred during a request.
///
/// [response] can be `null`.
typedef void OnError(Response response);

/// Used when a request timed out.
typedef void OnTimeout();

/// Takes a [Request] and handles its response.
///
/// The generic type `T` should be the return type of the [onSuccess] callback.
///
/// If [onTimout] is omitted [onError] will be called when a timeout occurs.
///
/// If [onError] is omitted it returns a [Future.error] with the response.
Future<T> handleRequest<T>(
  Future<Response> request, {
  OnSuccess<T> onSuccess,
  OnError onError,
  OnTimeout onTimeout,
}) async {
  final response = await request.catchError((error) async {
    // request error
    _log.severe("error during request: $error");

    if (error is TimeoutException && onTimeout != null) {
      if (onTimeout is Future) {
        await onTimeout();
      } else {
        onTimeout();
      }
    } else if (onError != null) {
      if (onError is Future) {
        await onError(null);
      } else {
        onError(null);
      }
    } else {
      return Future.error(null);
    }
  });

  if (response != null) {
    final url = response.request.url;

    if (response.statusCode == 200) {
      // response success
      _log.fine("got 200 response for $url");

      if (onSuccess != null) {
        if (onSuccess is Future) {
          return await onSuccess(response);
        } else {
          return onSuccess(response);
        }
      }
    } else {
      // response error
      _log.severe("got ${response.statusCode} response for $url");

      if (onError != null) {
        if (onError is Future) {
          await onError(response);
        } else {
          onError(response);
        }
      } else {
        return Future.error(response);
      }
    }
  }

  return null;
}
