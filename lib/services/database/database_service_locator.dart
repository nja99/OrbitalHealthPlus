import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

// Create a singleton instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;


/// Sets up the authentication services for dependency injection.
void setUpDatabaseServices() {
  
  // Register FirebaseFirestore as a lazy singleton. This means the instance will be created only when it's first needed.
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  // Register FirestoreService as a lazy singleton.
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  
}
