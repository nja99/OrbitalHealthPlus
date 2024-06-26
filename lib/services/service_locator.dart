import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/database/database_service_locator.dart';
import 'package:healthsphere/services/user/user_service_locator.dart';

final GetIt getIt = GetIt.instance;

void setUp() {
  setUpAuthServices();
  setUpDatabaseServices();
  setUpUserServices();

  // Register RemoteConfig as Lazy Singleton
  getIt.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);
}
