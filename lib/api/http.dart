import 'package:harpy/api/dispatcher.dart';
import 'package:harpy/api/request_data.dart';
import 'package:http/http.dart' as http;

class Http {
  Dispatcher _dispatcher;

  set dispatcher(Dispatcher dispatcher) => _dispatcher = dispatcher;

  Future<http.Response> get(String url, {Map<String, String> headers}) {
    _invokeDispatcher("GET", url, headers);
    return http.get(url, headers: headers);
  }

  Future<http.Response> post(String url, {Map<String, String> headers, body}) {
    _invokeDispatcher("POST", url, headers, body: body);
    return http.post(url, headers: headers);
  }

  _invokeDispatcher(String method, String url, Map<String, String> headers,
      {body}) {
    if (headers == null) {
      headers = new Map<String, String>();
    }
    _dispatcher?.send(RequestData(method, url, headers, body));
  }
}
