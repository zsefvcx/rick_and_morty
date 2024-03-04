import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/core/usecases/usecase.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/reposytories/person_repository.dart';

class SearchPerson extends UseCase<PersonEntity, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson({required this.personRepository});

  ///можно явно не указыать метод call
  ///searchPerson.call(page: 1); => searchPerson(page: 1);
  @override
  Future<(Failure?, List<PersonEntity>?)> call(
      {required SearchPersonParams params}) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  const SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [
        query,
      ];
}
