import 'dart:convert';

/// Used by [mapJson] to map the [json] object to a dart object.
typedef JsonMapper<T> = T Function(Map<String, dynamic> json);

/// Maps the json string [data] to [T].
///
/// Returns a list of type [T] if the [data] is a json list, the object of type
/// [T] if the [data] is a json object or `null`.
dynamic mapJson<T>(String data, JsonMapper<T> mapper) {
  final json = jsonDecode(data);

  if (json is List) {
    final decodedObjects = <T>[];

    for (Map<String, dynamic> object in json) {
      decodedObjects.add(mapper(object));
    }

    return decodedObjects;
  } else if (json is Map) {
    return mapper(json);
  } else {
    return null;
  }
}

/// Iterates over every entry in the [json] map and calls `toJson()` if possible
/// on every entry recursively.
Map<String, dynamic> toPrimitiveJson(Map<String, dynamic> json) {
  return json.map((key, value) {
    dynamic jsonValue = _toJsonValue(value);

    if (jsonValue is Map) {
      jsonValue = toPrimitiveJson(jsonValue);
    } else if (jsonValue is List) {
      jsonValue = _listToPrimitiveJson(jsonValue);
    }

    return MapEntry<String, dynamic>(key, jsonValue);
  });
}

List<dynamic> _listToPrimitiveJson(List<dynamic> jsonList) {
  return jsonList.map((value) {
    final jsonValue = _toJsonValue(value);

    if (jsonValue is Map) {
      return toPrimitiveJson(jsonValue);
    } else if (jsonValue is List) {
      return _listToPrimitiveJson(jsonValue);
    } else {
      return jsonValue;
    }
  }).toList();
}

dynamic _toJsonValue(dynamic value) {
  try {
    return value.toJson();
  } on NoSuchMethodError {
    return value;
  }
}
