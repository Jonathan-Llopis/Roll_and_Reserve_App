import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:roll_and_reserve/main.dart';
import 'package:roll_and_reserve/presentation/screens/screen_chat.dart';
import 'package:roll_and_reserve/presentation/screens/screen_create_event.dart';
import 'package:roll_and_reserve/presentation/screens/screen_create_reserve.dart';
import 'package:roll_and_reserve/presentation/screens/screen_event.dart';
import 'package:roll_and_reserve/presentation/screens/screen_last_players.dart';
import 'package:roll_and_reserve/presentation/screens/screen_map_shops.dart';
import 'package:roll_and_reserve/presentation/screens/screen_qr.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserve.dart';
import 'package:roll_and_reserve/presentation/screens/screen_login.dart';
import 'package:roll_and_reserve/presentation/screens/screen_register.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserves_table.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserves_user.dart';
import 'package:roll_and_reserve/presentation/screens/screen_review_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_edit_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_review_user.dart';
import 'package:roll_and_reserve/presentation/screens/screen_shop_events.dart';
import 'package:roll_and_reserve/presentation/screens/screen_tables_shop.dart';
import 'package:roll_and_reserve/presentation/screens/screen_main.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roll_and_reserve/injection.dart' as di;

// final _shopBloc = sl<ShopBloc>();
// final _tableBloc = sl<TableBloc>();
// final _reserveBloc = sl<ReserveBloc>();
// final _reviewsBloc = sl<ReviewBloc>();

PreferredSizeWidget appBar = DefaultAppBar();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/user',
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScreenLogin(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
      routes: [
        GoRoute(
          name: 'register',
          path: 'signIn',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ScreenRegister(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        ),
      ],
    ),
    GoRoute(
      name: 'user',
      path: '/user',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: ScreenMain(appBar: appBar),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
      routes: [
        GoRoute(
          name: 'editShop',
          path: 'shop_edit/:idEditShop',
          pageBuilder: (context, state) {
            final shopId = int.parse(state.pathParameters['idEditShop']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ScreenEditShop(idShop: shopId, appBar: appBar),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          name: 'chat',
          path: 'chat',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: ChatScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          name: 'lastUsers',
          path: '/lastUsers',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: ScreenLastPlayers(appBar: appBar),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        ),
        GoRoute(
          name: 'map',
          path: '/map',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: StoreMap(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        ),
        GoRoute(
          name: 'events',
          path: 'events/:idShop',
          pageBuilder: (context, state) {
            final shopId = int.parse(state.pathParameters['idShop']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ScreenShopEvents(idShop: shopId, appBar: appBar),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
          routes: [
            GoRoute(
              name: 'createEvent',
              path: 'createEvent',
              pageBuilder: (context, state) {
                final shopId = int.parse(state.pathParameters['idShop']!);
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ScreenCreateEvent(idShop: shopId, appBar: appBar),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );
              },
            ),
            GoRoute(
              name: 'eventReserve',
              path: 'eventReserve/:idReserve',
              pageBuilder: (context, state) {
                final idReserve = int.parse(state.pathParameters['idReserve']!);
                final shopId = int.parse(state.pathParameters['idShop']!);
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ScreenEvent(
                      idReserve: idReserve, idShop: shopId, appBar: appBar),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: 'userReserves',
          path: 'userReserves',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: ScreenReservesOfUser(appBar: appBar),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
          
        ),
        GoRoute(
          name: 'tablesShop',
          path: 'shop/:idTablesShop',
          pageBuilder: (context, state) {
            final idShop = int.parse(state.pathParameters['idTablesShop']!);
            return CustomTransitionPage(
              key: state.pageKey,
              child: ScreenTablesOfShop(idShop: idShop, appBar: appBar),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
          routes: [
            GoRoute(
              name: 'storeReviews',
              path: 'raiting',
              pageBuilder: (context, state) {
                final idShop = int.parse(state.pathParameters['idTablesShop']!);
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ScreenReviewShop(idShop: idShop, appBar: appBar),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );
              },
            ),
            GoRoute(
              name: 'reservations',
              path: 'table/:idTable',
              pageBuilder: (context, state) {
                final tableId = int.parse(state.pathParameters['idTable']!);
                final idShop = int.parse(state.pathParameters['idTablesShop']!);
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: ScreenReservesOfTable(
                      idTable: tableId, idShop: idShop, appBar: appBar),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                );
              },
              routes: [
                GoRoute(
                  name: 'createReserve',
                  path: 'createReserve/:dateSearch',
                  pageBuilder: (context, state) {
                    final idShop =
                        int.parse(state.pathParameters['idTablesShop']!);
                    final idTable = int.parse(state.pathParameters['idTable']!);
                    final dateSearch = state.pathParameters['dateSearch'];
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: ScreenCreateReserve(
                          idShop: idShop,
                          idTable: idTable,
                          searchDateTimeString: dateSearch!,
                          appBar: appBar),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      },
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
    final isLoggedIn = await di.sl<UserRespository>().isLoggedIn();
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
