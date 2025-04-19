import 'package:voldt/core/error/exception.dart';
import 'package:voldt/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voldt/features/auth/domain/entitites/user.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';
import 'package:voldt/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _getUser(
      () async => await remoteDataSource
          .logInWithEmailAndPassword(email, password),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    return _getUser(
      () async =>
          await remoteDataSource.signUpWithEmailAndPassword(
            name,
            email,
            password,
          ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
