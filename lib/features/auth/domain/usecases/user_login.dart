import 'package:voldt/core/error/failures.dart';
import 'package:voldt/core/usecase/usecase.dart';
import 'package:voldt/core/common/cubit/app_user/entitites/user.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(
    UserLoginParams params,
  ) async {
    return await authRepository.logInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
