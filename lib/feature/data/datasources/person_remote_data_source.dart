import 'dart:convert';
import 'dart:developer' as dev;

import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemouteDataSource {
  ///Calls the https://rickandmortyapi.com/api/character/?page=1 endpoint.
  ///
  /// Throw a [ServerExeption] for all errors codes.
  Future<List<PersonModel>> getAllPersons(int page);

  ///Calls the https://rickandmortyapi.com/api/character/?name=rick endpoint.
  ///
  /// Throw a [ServerExeption] for all errors codes.
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonPemouteDataSourceImpl implements PersonRemouteDataSource {
  final http.Client client;

  PersonPemouteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    dev.log(url, error: false, time: DateTime.now());
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application:json'});
    if (response.statusCode == 200) {
      final personse = json.decode(response.body);
      return (personse['results'] as List)
          .map((e) => PersonModel.fromJson(e))
          .toList();
    } else {
      throw ServerExeption();
    }
  }
}
