import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserRepository extends Mock implements UserRespository {}
class MockReserveRepository extends Mock implements ReserveRepository {}
class MockShopRepository extends Mock implements ShopsRepository {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
