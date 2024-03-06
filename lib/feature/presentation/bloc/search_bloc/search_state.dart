import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();
}

class PersonSearchEmty extends PersonSearchState {
  @override
  List<Object?> get props => [];
}

class PersonSearchLoading extends PersonSearchState {
  final List<PersonEntity> oldPersonsList;
  final bool isFirstFetch;

  const PersonSearchLoading({
    required this.oldPersonsList,
    required this.isFirstFetch,
  });

  @override
  List<Object?> get props => [oldPersonsList, isFirstFetch];
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
