import 'package:harpy/api/request_data.dart';

abstract class Dispatcher {
  send(RequestData requestData);
}
