import 'dart:convert';

/// Used by [mapJson] to map the [json] object to a dart object.
typedef T JsonMapper<T>(Map<String, dynamic> json);

/// Maps the json string [data] to [T].
///
/// Returns a list of type [T] if the [data] is a json list, the object of type
/// [T] if the [data] is a json object or `null`.
dynamic mapJson<T>(String data, JsonMapper<T> mapper) {
  dynamic json = jsonDecode(data);

  if (json is List) {
    List<T> decodedObjects = [];

    for (Map<String, dynamic> object in json) {
//      _printObject(object, 0);

      decodedObjects.add(mapper(object));
    }

    return decodedObjects;
  } else if (json is Map) {
    return mapper(json);
  } else {
    return null;
  }
}

void _printObject(Map<String, dynamic> object, int level) {
  print("${"  " * level * 2}----------");
  object.forEach((key, value) {
    if (value is Map) {
      print("${"  " * level * 2}$key:");
      _printObject(value, level + 1);
    }
    print("${"  " * level * 2}$key: ${value.toString()}");
  });
  print("${"  " * level * 2}----------");
}
