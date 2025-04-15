import 'package:fpdart/fpdart.dart';
import 'package:voldt/core/error/failures.dart';
import 'package:voldt/features/auth/domain/entitites/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, User>> logInWithEmailAndPassword(
    String email,
    String password,
  );
}
