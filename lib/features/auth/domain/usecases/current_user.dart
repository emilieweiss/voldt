import 'package:fpdart/fpdart.dart';
import 'package:voldt/core/error/failures.dart';
import 'package:voldt/core/usecase/usecase.dart';
import 'package:voldt/features/auth/domain/entitites/user.dart';
import 'package:voldt/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(
    NoParams params,
  ) async {
    return await authRepository.currentUser();
  }
}
