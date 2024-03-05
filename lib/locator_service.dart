import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rick_and_morty/core/platform/network_info.dart';
import 'package:rick_and_morty/feature/data/datasources/person_local_data_source.dart';
import 'package:rick_and_morty/feature/data/datasources/person_remote_data_source.dart';
import 'package:rick_and_morty/feature/data/reposytories/person_repository_impl.dart';
import 'package:rick_and_morty/feature/domain/reposytories/person_repository.dart';
import 'package:rick_and_morty/feature/domain/usecases/get_all_persons.dart';
import 'package:rick_and_morty/feature/domain/usecases/search_peson.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/presentation/bloc/search_bloc/search_block.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc / Cubit
  sl.registerFactory(
    () => PersonListCubit(getAllPersons: sl()),
  );
  sl.registerFactory(
    () => PersonSearchBloc(searchPerson: sl()),
  );
  //UseCases
  sl.registerLazySingleton(
    () => GetAllPersons(personRepository: sl()),
  );
  sl.registerLazySingleton(
    () => SearchPerson(personRepository: sl()),
  );
  //Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remouteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PersonRemouteDataSource>(
    () => PersonRemouteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<PersonLocaleDataSource>(
    () => PersonLocaleDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  //core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectionChecker: sl(),
    ),
  );

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
