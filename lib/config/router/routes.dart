import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserve.dart';
import 'package:roll_and_reserve/presentation/screens/screen_login.dart';
import 'package:roll_and_reserve/presentation/screens/screen_register.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserves_table.dart';
import 'package:roll_and_reserve/presentation/screens/screen_review_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_edit_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_tables_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_main.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roll_and_reserve/injection.dart' as di;

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/signIn',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserScreen(),
    ),
    GoRoute(
        path: '/user/shop_edit/:id',
        builder: (context, state) {
          final shopId = int.parse(state.pathParameters['id']!);
          return EditStoreForm(idShop: shopId);
        }),
    GoRoute(
        path: '/user/shop/:id',
        builder: (context, state) {
          final shopId = int.parse(state.pathParameters['id']!);
          return TablesScreen(idShop: shopId);
        }),
    GoRoute(
        path: '/user/shop/raiting/:idShop',
        builder: (context, state) {
          final idShop = int.parse(state.pathParameters['idShop']!);
          return StoreReviewsPage(
            idShop: idShop,
          );
        }),
    GoRoute(
        path: '/user/shop/table/:idTable:idShop',
        builder: (context, state) {
          final tableId = int.parse(state.pathParameters['idTable']!);
          final idShop = int.parse(state.pathParameters['idShop']!);
          return ReservationsScreen(
            idTable: tableId,
            idShop: idShop,
          );
        }),
    GoRoute(
        path: '/user/shop/table/reserve/:idReserve:idShop',
        builder: (context, state) {
          final idReserve = int.parse(state.pathParameters['idReserve']!);
          final idShop = int.parse(state.pathParameters['idShop']!);
          return GameReserveScreen(idReserve: idReserve, idShop: idShop);
        }),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await di.sl<LoginRepository>().isLoggedIn();
    final sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');

    if (!state.matchedLocation.contains("/login") && email == null) {
      return '/login';
    } else {
      if (state.matchedLocation.startsWith('/login')) {
        return null;
      } else {
        return isLoggedIn.fold(
          (_) => '/login',
          (loggedIn) => state.matchedLocation,
        );
      }
    }
  },
);
