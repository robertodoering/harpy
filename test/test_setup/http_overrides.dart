import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';

import '../images/transparent_image.dart';

/// Used to override the http client in tests to mock network images.
///
/// Requested images will use the uri path to load local images instead
/// (in `test/images/`), or fallback to a transparent image.
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = _MockHttpClient();

    when(() => client.getUrl(any())).thenAnswer((invocation) async {
      final Uri uri = invocation.positionalArguments[0];

      return _MockHttpClientRequest(uri);
    });

    return client;
  }
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    void _fallback() {}
    registerFallbackValue(_fallback);
    registerFallbackValue(Uri());
  }
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {
  _MockHttpClientRequest(Uri uri) {
    when(() => headers).thenReturn(_MockHttpHeaders());
    when(close).thenAnswer((_) async => _MockHttpClientResponse(uri));
  }
}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {
  _MockHttpClientResponse(Uri uri) {
    Uint8List imageData;

    try {
      imageData = File(uri.path).readAsBytesSync();
    } catch (e) {
      imageData = kTransparentImage;
    }

    when(() => compressionState).thenReturn(
      HttpClientResponseCompressionState.notCompressed,
    );
    when(() => contentLength).thenReturn(imageData.length);
    when(() => statusCode).thenReturn(HttpStatus.ok);

    when(
      () => listen(
        any(),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
        cancelOnError: any(named: 'cancelOnError'),
      ),
    ).thenAnswer((invocation) {
      final void Function(List<int>) onData = invocation.positionalArguments[0];
      final void Function() onDone = invocation.namedArguments[#onDone];
      final Function onError = invocation.namedArguments[#onError];
      final bool cancelOnError = invocation.namedArguments[#cancelOnError];

      return Stream<List<int>>.fromIterable([imageData]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
    });
  }
}

class _MockHttpHeaders extends Mock implements HttpHeaders {}
