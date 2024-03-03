import 'package:equatable/equatable.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/core/usecases/usecase.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/reposytories/person_repository.dart';

class GetAllPersons extends UseCase<PersonEntity, PagePersonParams> {
  final PersonRepository personRepository;

  GetAllPersons({required this.personRepository});

  ///можно явно не указыать метод call
  ///getAllPersons.call(page: 1); => getAllPersons(page: 1);
  @override
  Future<(Failure, List<PersonEntity>)> call(
      {required PagePersonParams params}) async {
    return await personRepository.getAllPersons(params.page);
  }
}

class PagePersonParams extends Equatable {
  final int page;

  const PagePersonParams({required this.page});

  @override
  List<Object?> get props => [
        page,
      ];
}
