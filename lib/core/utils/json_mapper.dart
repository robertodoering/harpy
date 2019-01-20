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
      decodedObjects.add(mapper(object));
    }

    return decodedObjects;
  } else if (json is Map) {
    return mapper(json);
  } else {
    return null;
  }
}
