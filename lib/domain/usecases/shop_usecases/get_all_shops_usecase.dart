import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

import '../../entities/shop_entity.dart';

class GetAllShopsParams extends Equatable {
  final int page;
  final int limit;

  const GetAllShopsParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class GetAllShopsUseCase
    implements UseCase<Either<Failure, List<ShopEntity>>, dynamic> {
  final ShopsRepository repository;
  GetAllShopsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ShopEntity>>> call(dynamic params) async {
    int page = 1;
    int limit = 20;
    if (params is GetAllShopsParams) {
      page = params.page;
      limit = params.limit;
    }
    return repository.getAllShops(page: page, limit: limit);
  }
}
