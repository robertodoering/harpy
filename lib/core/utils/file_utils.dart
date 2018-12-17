import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

String convertFileToBase64({@required File media}) {
  List<int> bytes = media.readAsBytesSync();
  return base64Encode(bytes);
}
