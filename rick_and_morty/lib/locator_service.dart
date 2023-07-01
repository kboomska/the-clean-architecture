import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/data/data_sources/person_remote_data_source.dart';
import 'package:rick_and_morty/feature/data/data_sources/person_local_data_source.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:rick_and_morty/feature/data/repositories/person_repository_impl.dart';
import 'package:rick_and_morty/feature/domain/repositories/person_repository.dart';
import 'package:rick_and_morty/feature/domain/use_cases/get_all_persons.dart';
import 'package:rick_and_morty/feature/domain/use_cases/search_person.dart';
import 'package:rick_and_morty/core/platform/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc / Cubit
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllPersons(personRepository: sl()));
  sl.registerLazySingleton(() => SearchPerson(personRepository: sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
        remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(client: http.Client()),
  );
  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
