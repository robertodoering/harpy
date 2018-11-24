import 'dart:convert';

abstract class JsonMapper<T> {
  dynamic map(T mapSingleType(Map<String, dynamic> data), String data) {
    var objects = jsonDecode(data);
    print(objects);
    if (objects is List) {
      List<T> decodedObjects = [];
      Set<Map<String, dynamic>> set = Set.from(objects);
      set.forEach((currentObj) {
        decodedObjects.add(mapSingleType(currentObj));

        print(" ----- ");
        currentObj.forEach((val1, val2) => print("$val1: $val2"));
        print(" ----- ");
      });
      return decodedObjects;
    } else {
      return mapSingleType(objects);
    }
  }
}
