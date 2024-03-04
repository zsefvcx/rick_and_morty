import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();
}

class PersonEmty extends PersonSearchState {
  @override
  List<Object?> get props => [];
}

class PersonSearchLoading extends PersonSearchState {
  @override
  List<Object?> get props => [];
}

class PersonSearchLoaded extends PersonSearchState {
  final List<PersonEntity> persons;

  const PersonSearchLoaded({required this.persons});

  @override
  List<Object?> get props => [persons];
}

class PersonSearchError extends PersonSearchState {
  final String massage;

  const PersonSearchError({required this.massage});

  @override
  List<Object?> get props => [massage];
}
