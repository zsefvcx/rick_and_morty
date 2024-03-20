import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

sealed class PersonState extends Equatable {
  const PersonState();
}

class PersonEmpty extends PersonState {
  @override
  List<Object?> get props => [];
}

class PersonLoading extends PersonState {
  final List<PersonEntity> oldPersonsList;
  final bool isFirstFetch;

  const PersonLoading({
    required this.oldPersonsList,
    required this.isFirstFetch,
  });

  @override
  List<Object?> get props => [oldPersonsList, isFirstFetch];
}

class PersonLoaded extends PersonState {
  final List<PersonEntity> personsList;

  const PersonLoaded({required this.personsList});

  @override
  List<Object?> get props => [personsList];
}

class PersonError extends PersonState {
  final String message;

  const PersonError({required this.message});

  @override
  List<Object?> get props => [message];
}
