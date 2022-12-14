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
      final uri = invocation.positionalArguments[0] as Uri;

      return _MockHttpClientRequest(uri);
    });

    return client;
  }
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    void fallback() {}
    registerFallbackValue(fallback);
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

    String preparePath(String path) {
      final splitPath = path.split('/');
      splitPath.insert(splitPath.length - 1, 'test/images');

      return splitPath.join('/');
    }

    try {
      imageData = File(preparePath(uri.path)).readAsBytesSync();
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
      final onData = invocation.positionalArguments[0] as void Function(
        List<int>,
      );
      final onDone = invocation.namedArguments[#onDone] as void Function();
      final onError = invocation.namedArguments[#onError] as Function;
      final cancelOnError = invocation.namedArguments[#cancelOnError] as bool;

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
