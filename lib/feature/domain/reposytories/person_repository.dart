import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<(Failure?, List<PersonEntity>?)> getAllPersons(int page);
  Future<(Failure?, List<PersonEntity>?)> searchPerson(String query, int page);
}
