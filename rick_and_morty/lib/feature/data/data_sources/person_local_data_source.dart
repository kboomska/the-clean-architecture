import 'dart:convert';

import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rick_and_morty/core/error/exception.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const cachedPersonsList = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList =
        sharedPreferences.getStringList(cachedPersonsList) ?? [];
    if (jsonPersonsList.isNotEmpty) {
      return Future.value(
        jsonPersonsList
            .map(
              (person) => PersonModel.fromJson(json.decode(person)),
            )
            .toList(),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonsList = persons
        .map(
          (person) => json.encode(person.toJson()),
        )
        .toList();

    await sharedPreferences.setStringList(cachedPersonsList, jsonPersonsList);
    print('Persons to write Cache: ${jsonPersonsList.length}');
    // return Future.value(jsonPersonsList);
  }
}
