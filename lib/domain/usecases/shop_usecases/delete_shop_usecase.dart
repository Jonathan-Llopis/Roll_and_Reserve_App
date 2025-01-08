import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class DeleteShopsUseCase implements UseCase<Either<Exception, bool>, int> {
  final ShopsRepository repository;
  DeleteShopsUseCase(this.repository);

  @override
  Future<Either<Exception, bool>> call(int idShops) async {
    return repository.deleteShops(idShops);
  }
}