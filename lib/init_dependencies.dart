import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/core/secrets/app_secrets.dart';
import 'package:voldt/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voldt/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';
import 'package:voldt/features/auth/domain/usecases/current_user.dart';
import 'package:voldt/features/auth/domain/usecases/user_login.dart';
import 'package:voldt/features/auth/domain/usecases/user_sign_up.dart';
import 'package:voldt/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );
  _initAuth();
}

void _initAuth() {
  // Data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    // Use cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
      ),
    );
}
