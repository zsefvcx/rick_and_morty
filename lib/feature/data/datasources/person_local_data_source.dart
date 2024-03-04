import 'dart:convert';
import 'dart:developer' as dev;

import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocaleDataSource {
  /// Gets the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throw [CacheExeption] if no cached data in present.

  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personToCache(List<PersonModel> persons);
}

const cachedPersonList = 'CACHED_PERSON_LIST';

class PersonLocaleDataSourceImpl implements PersonLocaleDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocaleDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> personToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonList =
        persons.map((e) => json.encode(e.toJson())).toList();
    var done =
        await sharedPreferences.setStringList(cachedPersonList, jsonPersonList);
    if (done) {
      dev.log('Person to write Cache: ${jsonPersonList.length}',
          error: false, time: DateTime.now());
    } else {
      throw CacheExeption();
    }
  }

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final List<String> jsonPersonList =
        sharedPreferences.getStringList(cachedPersonList) ?? <String>[];
    if (jsonPersonList.isNotEmpty) {
      return Future.value(jsonPersonList
          .map((e) => PersonModel.fromJson(json.decode(e)))
          .toList());
    } else {
      throw CacheExeption();
    }
  }
}
