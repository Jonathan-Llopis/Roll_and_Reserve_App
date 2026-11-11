import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/create_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/delete_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_byowner_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_most_played_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_peak_reservation_houts_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_player_count_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_total_reservations_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/update_shop_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';

class MockCreateShopsUseCase extends Mock implements CreateShopsUseCase {}
class MockGetAllShopsUseCase extends Mock implements GetAllShopsUseCase {}
class MockUpdateShopsUseCase extends Mock implements UpdateShopsUseCase {}
class MockDeleteShopsUseCase extends Mock implements DeleteShopsUseCase {}
class MockGetShopUseCase extends Mock implements GetShopUseCase {}
class MockGetAllShopsByOwnerUseCase extends Mock implements GetAllShopsByOwnerUseCase {}
class MockGetMostPlayedGamesUseCase extends Mock implements GetMostPlayedGamesUseCase {}
class MockGetTotalReservationsUseCase extends Mock implements GetTotalReservationsUseCase {}
class MockGetPlayerCountUseCase extends Mock implements GetPlayerCountUseCase {}
class MockGetPeakReservationHoursUseCase extends Mock implements GetPeakReservationHoursUseCase {}

void main() {
  late MockCreateShopsUseCase mockCreateShopsUseCase;
  late MockGetAllShopsUseCase mockGetAllShopsUseCase;
  late MockUpdateShopsUseCase mockUpdateShopsUseCase;
  late MockDeleteShopsUseCase mockDeleteShopsUseCase;
  late MockGetShopUseCase mockGetShopUseCase;
  late MockGetAllShopsByOwnerUseCase mockGetAllShopsByOwnerUseCase;
  late MockGetMostPlayedGamesUseCase mockGetMostPlayedGamesUseCase;
  late MockGetTotalReservationsUseCase mockGetTotalReservationsUseCase;
  late MockGetPlayerCountUseCase mockGetPlayerCountUseCase;
  late MockGetPeakReservationHoursUseCase mockGetPeakReservationHoursUseCase;

  setUpAll(() {
    registerFallbackValue(const GetAllShopsParams());
  });

  setUp(() {
    mockCreateShopsUseCase = MockCreateShopsUseCase();
    mockGetAllShopsUseCase = MockGetAllShopsUseCase();
    mockUpdateShopsUseCase = MockUpdateShopsUseCase();
    mockDeleteShopsUseCase = MockDeleteShopsUseCase();
    mockGetShopUseCase = MockGetShopUseCase();
    mockGetAllShopsByOwnerUseCase = MockGetAllShopsByOwnerUseCase();
    mockGetMostPlayedGamesUseCase = MockGetMostPlayedGamesUseCase();
    mockGetTotalReservationsUseCase = MockGetTotalReservationsUseCase();
    mockGetPlayerCountUseCase = MockGetPlayerCountUseCase();
    mockGetPeakReservationHoursUseCase = MockGetPeakReservationHoursUseCase();
  });

  const shop1 = ShopEntity(
    id: 1,
    name: 'Shop 1',
    address: 'Street 1',
    logo: null,
    averageRaiting: 4.5,
    logoId: 'logo1',
    ownerId: 'owner1',
    tablesShop: [1],
    gamesShop: [1],
    latitude: 40.0,
    longitude: -3.0,
  );

  const shop2 = ShopEntity(
    id: 2,
    name: 'Shop 2',
    address: 'Street 2',
    logo: null,
    averageRaiting: 4.8,
    logoId: 'logo2',
    ownerId: 'owner2',
    tablesShop: [2],
    gamesShop: [2],
    latitude: 40.1,
    longitude: -3.1,
  );

  const shop3 = ShopEntity(
    id: 3,
    name: 'Shop 3',
    address: 'Street 3',
    logo: null,
    averageRaiting: 4.2,
    logoId: 'logo3',
    ownerId: 'owner3',
    tablesShop: [3],
    gamesShop: [3],
    latitude: 40.2,
    longitude: -3.2,
  );

  ShopBloc buildBloc() => ShopBloc(
        createShopsUseCase: mockCreateShopsUseCase,
        getShopsUseCase: mockGetAllShopsUseCase,
        updateShopsUseCase: mockUpdateShopsUseCase,
        deleteShopsUseCase: mockDeleteShopsUseCase,
        getShopUseCase: mockGetShopUseCase,
        getAllShopsByOwnerUseCase: mockGetAllShopsByOwnerUseCase,
        getMostPlayedGames: mockGetMostPlayedGamesUseCase,
        getTotalReservations: mockGetTotalReservationsUseCase,
        getPlayerCount: mockGetPlayerCountUseCase,
        getPeakReservationHours: mockGetPeakReservationHoursUseCase,
      );

  group('ShopBloc Pagination', () {
    test('initial state has default pagination values', () {
      final bloc = buildBloc();
      expect(bloc.state.currentPage, equals(1));
      expect(bloc.state.hasReachedMax, isFalse);
      expect(bloc.state.isLoadingMore, isFalse);
    });

    blocTest<ShopBloc, ShopState>(
      'loads first page of shops with GetShopsEvent',
      build: () {
        when(() => mockGetAllShopsUseCase(const GetAllShopsParams(page: 1, limit: 20)))
            .thenAnswer((_) async => const Right([shop1, shop2]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(GetShopsEvent()),
      expect: () => [
        isA<ShopLoading>().having((s) => s.currentPage, 'currentPage', 1),
        isA<ShopSuccess>()
            .having((s) => s.shops, 'shops', [shop1, shop2])
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.hasReachedMax, 'hasReachedMax', isTrue), // length < 20
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'appends second page of shops with FetchShopsNextPageEvent without duplicates',
      build: () {
        when(() => mockGetAllShopsUseCase(const GetAllShopsParams(page: 2, limit: 20)))
            .thenAnswer((_) async => const Right([shop3]));
        return buildBloc();
      },
      seed: () => const ShopSuccess(
        shops: [shop1, shop2],
        currentPage: 1,
        hasReachedMax: false,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.add(FetchShopsNextPageEvent()),
      expect: () => [
        const ShopSuccess(
          shops: [shop1, shop2],
          currentPage: 1,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        const ShopSuccess(
          shops: [shop1, shop2, shop3],
          currentPage: 2,
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'sets hasReachedMax to true when next page returns empty list',
      build: () {
        when(() => mockGetAllShopsUseCase(const GetAllShopsParams(page: 2, limit: 20)))
            .thenAnswer((_) async => const Right(<ShopEntity>[]));
        return buildBloc();
      },
      seed: () => const ShopSuccess(
        shops: [shop1, shop2],
        currentPage: 1,
        hasReachedMax: false,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.add(FetchShopsNextPageEvent()),
      expect: () => [
        const ShopSuccess(
          shops: [shop1, shop2],
          currentPage: 1,
          hasReachedMax: false,
          isLoadingMore: true,
        ),
        const ShopSuccess(
          shops: [shop1, shop2],
          currentPage: 1,
          hasReachedMax: true,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<ShopBloc, ShopState>(
      'ignores FetchShopsNextPageEvent if hasReachedMax is true',
      build: () => buildBloc(),
      seed: () => const ShopSuccess(
        shops: [shop1],
        currentPage: 1,
        hasReachedMax: true,
        isLoadingMore: false,
      ),
      act: (bloc) => bloc.add(FetchShopsNextPageEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetAllShopsUseCase(any()));
      },
    );

    blocTest<ShopBloc, ShopState>(
      'ignores FetchShopsNextPageEvent if isLoadingMore is already true',
      build: () => buildBloc(),
      seed: () => const ShopSuccess(
        shops: [shop1],
        currentPage: 1,
        hasReachedMax: false,
        isLoadingMore: true,
      ),
      act: (bloc) => bloc.add(FetchShopsNextPageEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetAllShopsUseCase(any()));
      },
    );
  });
}
