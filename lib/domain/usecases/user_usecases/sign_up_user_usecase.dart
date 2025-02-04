import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';

class SignUpUserUseCase implements UseCase<void, RegisterParams> {
  final UserRespository repository;
  SignUpUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    return repository.signUp(
        params.email, params.password, params.name, params.username);
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String username;
  RegisterParams(
      {required this.email,
      required this.password,
      required this.name,
      required this.username});
}
