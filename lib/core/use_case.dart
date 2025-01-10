abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}

class UserToReserveUseCaseParams {
  final int idReserve;
  final String idUser;

  UserToReserveUseCaseParams({required this.idReserve, required this.idUser});
}