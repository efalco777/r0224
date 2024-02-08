import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable()
class DataModel {
  final int id;
  /* 
    It would be a good idea to use an object here instead that would hold business constraints ex. max character length etc.
   */
  final String name;

  DataModel({required this.id, required this.name});

  factory DataModel.fromJson(Map<String, dynamic> json) => _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}