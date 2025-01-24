import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/create_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/delete_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_byowner_usecase%20copy.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/update_shop_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final CreateShopsUseCase createShopsUseCase;
  final GetAllShopsUseCase getShopsUseCase;
  final UpdateShopsUseCase updateShopsUseCase;
  final DeleteShopsUseCase deleteShopsUseCase;
  final GetShopUseCase getShopUseCase;
  final GetAllShopsByOwnerUseCase getAllShopsByOwnerUseCase;

  ShopBloc(this.createShopsUseCase, this.getShopsUseCase,
      this.updateShopsUseCase, this.deleteShopsUseCase, this.getShopUseCase, this.getAllShopsByOwnerUseCase)
      : super(const ShopState()) {
    on<GetShopsEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await getShopsUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ShopState.failure(state,"Fallo al realizar la recuperacion")),
        (shops) => emit(ShopState.getShops(state, shops)),
      );
    });

    on<GetShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result =
          await getShopUseCase(GetShopUseCaseParams(idShop: event.idShop));
      result.fold(
        (failure) =>
            emit(ShopState.failure(state,"Fallo al realizar la recuperacion")),
        (shop) {
          emit(ShopState.selectedShop(state,shop));
        },
      );
    });
    on<CreateShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await createShopsUseCase(event.shop);
      result.fold(
        (failure) => emit(ShopState.failure(state,"Fallo al crear tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsByOwnerEvent(owner: event.shop.ownerId));
        },
      );
    });
    on<UpdateShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await updateShopsUseCase(event.shop);
      result.fold(
        (failure) => emit(ShopState.failure(state,"Fallo al actualizar tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsByOwnerEvent(owner: event.shop.ownerId));
        },
      );
    });
    on<DeleteShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await deleteShopsUseCase(event.idShop);
      result.fold(
        (failure) => emit(ShopState.failure(state,"Fallo al eliminar tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsByOwnerEvent(owner: event.idOwner));
        },
      );
    });
    on<GetShopsByOwnerEvent>((event, emit) async {
      emit(ShopState.loading(state,));
      final result = await getAllShopsByOwnerUseCase(GetShopsByOwnerUseCaseParams( idOwner:event.owner));
      result.fold(
        (failure) =>
            emit(ShopState.failure(state,"Fallo al realizar la recuperacion")),
        (shopsByOwner) {
          emit(ShopState.getShops(state,shopsByOwner));
        },
      );
    });
    on<GetShopByFilterEvent>((event, emit) async {
      emit(ShopState.loading(state,));
      final result = await getShopsUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ShopState.failure(state,"Falló al realizar la recuperación")),
        (shops) {
          final filteredShops = shops.where((shop) {
            if (event.name != null && event.name!.isNotEmpty) {
              if (!shop.name
                  .toLowerCase()
                  .contains(event.name!.toLowerCase())) {
                return false;
              }
            }
            if (event.direction != null && event.direction!.isNotEmpty) {
              if (!shop.address
                  .toLowerCase()
                  .contains(event.direction!.toLowerCase())) {
                return false;
              }
            }
            return true;
          });
          emit(ShopState.getShops(state,filteredShops.toList()));
        },
      );
    });
  }
}
