import 'package:built_collection/built_collection.dart';
import 'package:json_annotation/json_annotation.dart';

class BuiltListConverter<T> implements JsonConverter<BuiltList<T>, Object?> {
  const BuiltListConverter();

  T valueFromJson(Map<String, dynamic> json) => throw UnimplementedError();

  @override
  BuiltList<T> fromJson(Object? jsonList) {
    return (jsonList! as List<dynamic>).map((json) {
      if (json is Map<String, dynamic>) {
        return valueFromJson(json);
      } else {
        // This will only work if `json` is a native JSON type:
        // num, String, bool, null, etc
        // *and* is assignable to `T`.
        return json as T;
      }
    }).toBuiltList();
  }

  @override
  Object? toJson(BuiltList<T> object) => object.toList();
}
