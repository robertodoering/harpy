import 'dart:convert';

/// Used by [mapJson] to map the [json] map to an object.
typedef T JsonMapper<T>(Map<String, dynamic> json);

/// Maps the [data] and returns an either an object list of type [T], the
/// object of type [T] or null if the data is a json list of json objects,
/// a json object or neither respectively.
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
