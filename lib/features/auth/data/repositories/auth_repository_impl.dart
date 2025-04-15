import 'package:voldt/core/error/exception.dart';
import 'package:voldt/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voldt/features/auth/domain/entitites/user.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';
import 'package:voldt/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> logInWithEmailAndPassword(
    String email,
    String password,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userId = await remoteDataSource
          .signUpWithEmailAndPassword(
            name,
            email,
            password,
          );
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
