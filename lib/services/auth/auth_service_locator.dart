import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

final GetIt getIt = GetIt.instance;

void setUpAuthServices() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthService>(() => AuthService());
}
