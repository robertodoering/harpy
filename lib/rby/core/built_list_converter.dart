import 'package:built_collection/built_collection.dart';
import 'package:json_annotation/json_annotation.dart';

class BuiltListIntConverter extends JsonConverter<BuiltList<int>, List<int>> {
  const BuiltListIntConverter();

  @override
  BuiltList<int> fromJson(List<int> json) => json.toBuiltList();

  @override
  List<int> toJson(BuiltList<int> object) => object.toList();
}

class BuiltListDoubleConverter
    extends JsonConverter<BuiltList<double>, List<double>> {
  const BuiltListDoubleConverter();

  @override
  BuiltList<double> fromJson(List<double> json) => json.toBuiltList();

  @override
  List<double> toJson(BuiltList<double> object) => object.toList();
}

class BuiltListBoolConverter
    extends JsonConverter<BuiltList<bool>, List<bool>> {
  const BuiltListBoolConverter();

  @override
  BuiltList<bool> fromJson(List<bool> json) => json.toBuiltList();

  @override
  List<bool> toJson(BuiltList<bool> object) => object.toList();
}

class BuiltListStringConverter
    extends JsonConverter<BuiltList<String>, List<String>> {
  const BuiltListStringConverter();

  @override
  BuiltList<String> fromJson(List<String> json) => json.toBuiltList();

  @override
  List<String> toJson(BuiltList<String> object) => object.toList();
}
