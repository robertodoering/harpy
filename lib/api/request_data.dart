class RequestData {
  String _method;
  String _url;
  dynamic _body;
  Map<String, String> _headers;

  RequestData(this._method, this._url, this._headers, this._body);

  String get url => _url;

  String get method => _method;

  Map<String, String> get headers => _headers;

  get body => _body;
}
