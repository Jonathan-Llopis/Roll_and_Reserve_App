abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}

class GetShopUseCaseParams {
  final int idShop;

  GetShopUseCaseParams( {required this.idShop});
}

class GetShopsByOwnerUseCaseParams {
  final String idOwner;

  GetShopsByOwnerUseCaseParams( {required this.idOwner});
}

class GetTablesByShopUseCaseParams {
  final int idShop;

  GetTablesByShopUseCaseParams( {required this.idShop});
}

class UserToReserveUseCaseParams {
  final int idReserve;
  final String idUser;

  UserToReserveUseCaseParams({required this.idReserve, required this.idUser});
}

class GetReservesByDateUseCaseParams {
  final DateTime date;
  final int idTable;

  GetReservesByDateUseCaseParams({required this.date, required this.idTable});
}

class GetReserveWithUsersUseCaseParams {
  final int idReserve;

  GetReserveWithUsersUseCaseParams({ required this.idReserve});
}