import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../data/data.dart';
import 'domain/domain.dart';
import 'service/navigation_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  /*---------------------------------------------------------------------------*/

  // Global
  sl.registerLazySingleton<RemoteGlobalApi>(() => RemoteGlobalApi());
  sl.registerLazySingleton<GlobalCountriesGetUseCase>(
    () => GlobalCountriesGetUseCaseImpl(),
  );
  sl.registerLazySingleton<GlobalRepository>(
    () => GlobalRepositoryImpl(remoteGlobalApi: sl()),
  );

  /*---------------------------------------------------------------------------*/

  //Singleton for HTTP request
  sl.registerLazySingleton(() => http.Client);

  sl.registerLazySingleton<RemoteUserApi>(() => RemoteUserApi());
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteUserApi: sl()),
  );

  sl.registerLazySingleton<RemoteAuthenticationApi>(
    () => RemoteAuthenticationApi(),
  );
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(remoteAuthenticationApi: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Homepage
  sl.registerLazySingleton<RemoteHomeApi>(() => RemoteHomeApi());
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteHomeApi: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Location
  sl.registerLazySingleton<RemoteLocationApi>(() => RemoteLocationApi());
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(remoteLocationApi: sl()),
  );

  // Outlet details
  sl.registerLazySingleton<LocationDetailGetUseCase>(
    () => LocationDetailGetUseCaseImpl(),
  );

  /*---------------------------------------------------------------------------*/

  // History
  sl.registerLazySingleton<RemoteHistoryApi>(() => RemoteHistoryApi());
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(remoteHistoryApi: sl()),
  );

  // History list
  sl.registerLazySingleton<HistoryListGetUseCase>(
    () => HistoryListGetUseCaseImpl(),
  );
  // Outlet details
  sl.registerLazySingleton<HistoryDetailGetUseCase>(
    () => HistoryDetailGetUseCaseImpl(),
  );
}
