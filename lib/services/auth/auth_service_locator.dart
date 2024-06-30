import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthsphere/services/auth/auth_service.dart';

// Create a singleton instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;

/// Sets up the authentication services for dependency injection.
void setUpAuthServices() {

  // Register FirebaseAuth as a lazy singleton. This means the instance will be created only when it's first needed.
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register AuthService as a lazy singleton.
  getIt.registerLazySingleton<AuthService>(() => AuthService());
}
