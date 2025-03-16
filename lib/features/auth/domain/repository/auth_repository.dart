import 'package:fpdart/fpdart.dart';
import 'package:voldt/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, String>> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<Either<Failures, String>> logInWithEmailAndPassword(
    String email,
    String password,
  );
}
