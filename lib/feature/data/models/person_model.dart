import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

part 'person_model.g.dart';

@JsonSerializable()
class PersonModel extends PersonEntity {
  const PersonModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
    required super.episode,
    required super.created,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PersonModelToJson(this);
}
