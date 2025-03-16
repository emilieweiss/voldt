import 'package:fpdart/fpdart.dart';
import 'package:voldt/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
