import 'package:fpdart/fpdart.dart';
import 'package:voldt/core/error/failures.dart';
import 'package:voldt/core/usecase/usecase.dart';
import 'package:voldt/core/common/cubit/app_user/entitites/user.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';

class UserSignUp
    implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(
    UserSignUpParams params,
  ) async {
    return await authRepository.signUpWithEmailAndPassword(
      params.name,
      params.email,
      params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
