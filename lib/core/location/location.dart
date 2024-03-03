import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  final String name;
  final String url;

  const Location({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [
        name,
        url,
      ];

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
