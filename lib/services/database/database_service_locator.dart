import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

final GetIt getIt = GetIt.instance;

void setUpDatabaseServices() {
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
}
