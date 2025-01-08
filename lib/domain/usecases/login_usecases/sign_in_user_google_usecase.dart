import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import '../../repositories/login_repository.dart';

class SigninUserGoogleUseCase implements UseCase<void, LoginParamsGoogle> {
  final LoginRepository repository;
  SigninUserGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LoginParamsGoogle params) async {
    return repository.signInGoogle();
  }
}

class LoginParamsGoogle {
  LoginParamsGoogle();
}
