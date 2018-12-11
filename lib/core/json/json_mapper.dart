import 'dart:convert';

abstract class JsonMapper<T> {
  dynamic map(T mapSingleType(Map<String, dynamic> data), String data) {
    var objects = jsonDecode(data);
//    print(objects);
    if (objects is List) {
      List<T> decodedObjects = [];
      Set<Map<String, dynamic>> set = Set.from(objects);
      set.forEach((currentObj) {
        decodedObjects.add(mapSingleType(currentObj));

//        print(" ----- ");
//        currentObj.forEach((val1, val2) {
//          if (val2 is Map) {
//            print("$val1:");
//            val2.forEach((val2_1, val2_2) => print("    $val2_1: $val2_2"));
//          } else {
//            print("$val1: $val2");
//          }
//        });
//        print(" ----- ");
      });
      return decodedObjects;
    } else {
      return mapSingleType(objects);
    }
  }
}
