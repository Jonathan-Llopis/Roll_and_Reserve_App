import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/config/di/di_chat.dart';
import 'package:roll_and_reserve/config/di/di_core.dart';
import 'package:roll_and_reserve/config/di/di_reservations.dart';
import 'package:roll_and_reserve/config/di/di_shops.dart';
import 'package:roll_and_reserve/core/network/api_client.dart';
import 'package:roll_and_reserve/core/network/token_provider.dart';
import 'package:roll_and_reserve/core/security/secure_storage_service.dart';
import 'package:roll_and_reserve/data/datasources/chat_local_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/get_chat_history_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GetIt testSl;

  setUp(() async {
    testSl = GetIt.asNewInstance();
    SharedPreferences.setMockInitialValues({'locale': 'en', 'token': 'abc'});
  });

  group('Modular Dependency Injection', () {
    test('registerShopDependencies registers shop, table and review blocs', () async {
      await registerCoreDependencies(testSl);
      registerShopDependencies(testSl);

      expect(testSl.isRegistered<ShopsRepository>(), isTrue);
      expect(testSl.isRegistered<ShopBloc>(), isTrue);
      expect(testSl.isRegistered<TableBloc>(), isTrue);
      expect(testSl.isRegistered<ReviewBloc>(), isTrue);

      final shopBloc = testSl<ShopBloc>();
      expect(shopBloc, isNotNull);
      final tableBloc = testSl<TableBloc>();
      expect(tableBloc, isNotNull);
      final reviewBloc = testSl<ReviewBloc>();
      expect(reviewBloc, isNotNull);
    });

    test('registerReservationDependencies registers reserve, game, event and player blocs', () async {
      await registerCoreDependencies(testSl);
      registerReservationDependencies(testSl);

      expect(testSl.isRegistered<ReserveRepository>(), isTrue);
      expect(testSl.isRegistered<ReserveBloc>(), isTrue);
      expect(testSl.isRegistered<GameBloc>(), isTrue);
      expect(testSl.isRegistered<EventBloc>(), isTrue);
      expect(testSl.isRegistered<PlayerBloc>(), isTrue);

      final gameBloc = testSl<GameBloc>();
      expect(gameBloc, isNotNull);
      final eventBloc = testSl<EventBloc>();
      expect(eventBloc, isNotNull);
      final playerBloc = testSl<PlayerBloc>();
      expect(playerBloc, isNotNull);
      final reserveBloc = testSl<ReserveBloc>();
      expect(reserveBloc, isNotNull);
    });

    test('registerChatDependencies registers chat bloc and repository', () async {
      registerChatDependencies(testSl);

      expect(testSl.isRegistered<ChatLocalDataSource>(), isTrue);
      expect(testSl.isRegistered<ChatRepository>(), isTrue);
      expect(testSl.isRegistered<GetChatHistoryUseCase>(), isTrue);
      expect(testSl.isRegistered<ChatBloc>(), isTrue);

      final chatBloc = testSl<ChatBloc>();
      expect(chatBloc, isNotNull);
    });

    test('registerCoreDependencies registers core services and LanguageBloc', () async {
      await registerCoreDependencies(testSl);

      expect(testSl.isRegistered<SharedPreferences>(), isTrue);
      expect(testSl.isRegistered<FlutterSecureStorage>(), isTrue);
      expect(testSl.isRegistered<SecureStorageService>(), isTrue);
      expect(testSl.isRegistered<TokenProvider>(), isTrue);
      expect(testSl.isRegistered<Dio>(), isTrue);
      expect(testSl.isRegistered<ApiClient>(), isTrue);
      expect(testSl.isRegistered<LanguageBloc>(), isTrue);

      final apiClient = testSl<ApiClient>();
      expect(apiClient, isNotNull);
      final languageBloc = testSl<LanguageBloc>();
      expect(languageBloc, isNotNull);
    });
  });
}
