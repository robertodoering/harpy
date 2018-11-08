import 'dart:convert';

abstract class JsonMapper<T> {
  dynamic map(T mapSingleType(Map<String, dynamic> data), String data) {
    var objects = jsonDecode(data);
    if (objects is List) {
      List<T> decodedObjects = [];
      Set<Map<String, dynamic>> set = Set.from(objects);
      set.forEach((currentObj) {
        decodedObjects.add(mapSingleType(currentObj));
      });
      return decodedObjects;
    } else {
      return mapSingleType(objects);
    }
  }
}
