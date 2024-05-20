import 'package:get_it/get_it.dart';
import 'user_profile_service.dart';

final GetIt getIt = GetIt.instance;

void setUpUserServices() {
  getIt.registerLazySingleton<UserProfileService>(() => UserProfileService());
}
