import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import '../../repositories/user_repository.dart';

class SigninUserUseCase implements UseCase<void, LoginParams> {
  final UserRespository repository;
  SigninUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LoginParams params) async {
    return repository.signIn(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}
