import 'package:get_it/get_it.dart';
import 'user_profile_service.dart';

// Create a singleton instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;

/// Sets up the authentication services for dependency injection.
void setUpUserServices() {

  // Register UserProfileService as a lazy singleton.
  getIt.registerLazySingleton<UserProfileService>(() => UserProfileService());
  
}
