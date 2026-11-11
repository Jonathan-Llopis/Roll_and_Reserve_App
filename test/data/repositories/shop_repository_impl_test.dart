import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/data/datasources/shop_datasource.dart';
import 'package:roll_and_reserve/data/models/shop_model.dart';
import 'package:roll_and_reserve/data/repositories/shop_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockShopRemoteDataSource extends Mock implements ShopRemoteDataSource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockShopRemoteDataSource mockRemoteDataSource;
  late MockSharedPreferences mockSharedPreferences;
  late ShopRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockShopRemoteDataSource();
    mockSharedPreferences = MockSharedPreferences();
    repository = ShopRepositoryImpl(mockRemoteDataSource, mockSharedPreferences);
    when(() => mockSharedPreferences.getString('token')).thenReturn('test-token');
  });

  group('ShopRepositoryImpl - N+1 Elimination', () {
    final tShopModels = [
      ShopModel(
        id: 1,
        name: 'Dungeon & Dice',
        address: 'Calle Mayor 1',
        logoId: 'logo_123',
        logo: null,
        averageRaiting: 4.5,
        ownerId: 'owner_1',
        tablesShop: const [1, 2],
        gamesShop: const [10, 20],
        latitude: 40.4168,
        longitude: -3.7038,
      ),
      ShopModel(
        id: 2,
        name: 'Dragon Tavern',
        address: 'Avenida Norte 4',
        logoId: 'logo_456',
        logo: null,
        averageRaiting: 4.8,
        ownerId: 'owner_2',
        tablesShop: const [3, 4],
        gamesShop: const [30],
        latitude: 41.3851,
        longitude: 2.1734,
      ),
    ];

    test('getAllShops returns shops immediately WITHOUT calling getShopLogo (eliminating N+1)', () async {
      when(() => mockRemoteDataSource.getAllShops(any(), page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => tShopModels);

      final result = await repository.getAllShops(page: 1, limit: 20);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (shops) {
          expect(shops.length, 2);
          expect(shops[0].name, 'Dungeon & Dice');
          expect(shops[0].logoId, 'logo_123');
          expect(shops[1].name, 'Dragon Tavern');
          expect(shops[1].logoId, 'logo_456');
        },
      );

      // Verify remoteDataSource.getAllShops was called once
      verify(() => mockRemoteDataSource.getAllShops('test-token', page: 1, limit: 20)).called(1);

      // Verify ZERO calls were made to getShopLogo
      verifyNever(() => mockRemoteDataSource.getShopLogo(any(), any()));
    });

    test('getShop returns shop without downloading logo binary', () async {
      when(() => mockRemoteDataSource.getShop(1, 'test-token'))
          .thenAnswer((_) async => tShopModels[0]);

      final result = await repository.getShop(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (shop) {
          expect(shop.id, 1);
          expect(shop.logoId, 'logo_123');
        },
      );

      verify(() => mockRemoteDataSource.getShop(1, 'test-token')).called(1);
      verifyNever(() => mockRemoteDataSource.getShopLogo(any(), any()));
    });

    test('getShopByOwner returns shops without downloading logo binary', () async {
      when(() => mockRemoteDataSource.getShopsByOwner('owner_1', 'test-token'))
          .thenAnswer((_) async => [tShopModels[0]]);

      final result = await repository.getShopByOwner('owner_1');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (shops) {
          expect(shops.length, 1);
          expect(shops[0].id, 1);
        },
      );

      verify(() => mockRemoteDataSource.getShopsByOwner('owner_1', 'test-token')).called(1);
      verifyNever(() => mockRemoteDataSource.getShopLogo(any(), any()));
    });

    test('ShopEntity exposes logoUrl correctly formatted', () {
      dotenv.testLoad(fileInput: 'BACKEND=http://api.rollandreserve.com\n');

      final shop = tShopModels[0].toShopEntity();
      expect(shop.logoUrl, 'http://api.rollandreserve.com/files/download/logo_123');
    });
  });
}
