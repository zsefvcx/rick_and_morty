import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/core/error/failure.dart';
import 'package:rick_and_morty/core/platform/network_info.dart';
import 'package:rick_and_morty/feature/data/datasources/person_remote_data_source.dart';
import 'package:rick_and_morty/feature/data/datasources/person_local_data_source.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/domain/reposytories/person_repository.dart';

class PersonRepositoryImpl extends PersonRepository {
  final PersonRemouteDataSource remouteDataSource;
  final PersonLocaleDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remouteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, List<PersonEntity>?)> getAllPersons(int page) async {
    return await _getPersons(
      () => remouteDataSource.getAllPersons(page),
    );
  }

  @override
  Future<(Failure?, List<PersonEntity>?)> searchPerson(
      String query, int page) async {
    return await _getPersons(
      () => remouteDataSource.searchPerson(query, page),
    );
  }

  Future<(Failure?, List<PersonModel>?)> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        localDataSource.personToCache(remotePerson);
        return (null, remotePerson);
      } on ServerExeption {
        return (ServerFailure(), null);
      }
    } else {
      try {
        final locationPerson = await localDataSource.getLastPersonsFromCache();
        return (null, locationPerson);
      } on CacheExeption {
        return (CacheFailure(), null);
      }
    }
  }
}
