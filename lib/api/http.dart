import 'package:harpy/api/dispatcher.dart';
import 'package:http/http.dart' as http;

class Http {
  Dispatcher _dispatcher;

  set dispatcher(Dispatcher dispatcher) => _dispatcher = dispatcher;

  Future<http.Response> get(String url, {Map<String, String> headers}) {
    _invokeDispatcher(url, headers);
    return http.get(url, headers: headers);
  }

  Future<http.Response> post(String url, {Map<String, String> headers}) {
    _invokeDispatcher(url, headers);
    return http.post(url, headers: headers);
  }

  _invokeDispatcher(String url, Map<String, String> headers) {
    _dispatcher?.send(url, headers);
  }
}
