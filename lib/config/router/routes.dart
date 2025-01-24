import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/screens/screen_create_reserve.dart';
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

final _shopBloc = sl<ShopBloc>();
final _tableBloc = sl<TableBloc>();
final _reserveBloc = sl<ReserveBloc>();
final _reviewsBloc = sl<ReviewBloc>();

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const ScreenLogin(),
      routes: [
        GoRoute(
          name: 'register',
          path: 'signIn',
          builder: (context, state) => const ScreenRegister(),
        ),
      ],
    ),
    GoRoute(
      name: 'user',
      path: '/user',
      builder: (context, state) => const ScreenMain(),
      routes: [
        GoRoute(
          name: 'editShop',
          path: 'shop_edit/:idEditShop',
          builder: (context, state) {
            final shopId = int.parse(state.pathParameters['idEditShop']!);
            return ScreenEditShop(idShop: shopId);
          },
        ),
        GoRoute(
          name: 'tablesShop',
          path: 'shop/:idTablesShop',
          builder: (context, state) {
            final idShop = int.parse(state.pathParameters['idTablesShop']!);
            return ScreenTablesOfShop(idShop: idShop);
          },
          routes: [
            GoRoute(
              name: 'storeReviews',
              path: 'raiting',
              builder: (context, state) {
                final idShop = int.parse(state.pathParameters['idTablesShop']!);
                return ScreenReviewShop(idShop: idShop);
              },
            ),
            GoRoute(
              name: 'reservations',
              path: 'table/:idTable',
              builder: (context, state) {
                final tableId = int.parse(state.pathParameters['idTable']!);
                final idShop = int.parse(state.pathParameters['idTablesShop']!);
                return ScreenReservesOfTable(idTable: tableId, idShop: idShop);
              },
              routes: [
                GoRoute(
                  name: 'gameReserve',
                  path: 'reserve/:idReserve',
                  builder: (context, state) {
                    final idReserve =
                        int.parse(state.pathParameters['idReserve']!);
                    final idShop =
                        int.parse(state.pathParameters['idTablesShop']!);
                    final idTable = int.parse(state.pathParameters['idTable']!);
                    return ScreenReserve(
                      idReserve: idReserve,
                      idShop: idShop,
                      idTable: idTable,
                    );
                  },
                ),
                 GoRoute(
                  name: 'createReserve',
                  path: 'createReserve',
                  builder: (context, state) {
                  
                    final idShop =
                        int.parse(state.pathParameters['idTablesShop']!);
                    final idTable = int.parse(state.pathParameters['idTable']!);
                    return ScreenCreateReserve(
                      idShop: idShop,
                      idTable: idTable,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
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
