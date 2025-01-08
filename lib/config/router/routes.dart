import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/presentation/screens/login_screen.dart';
import 'package:roll_and_reserve/presentation/screens/register_screen.dart';
import 'package:roll_and_reserve/presentation/screens/shop_edit_screen.dart';
import 'package:roll_and_reserve/presentation/screens/tables_screen.dart';
import 'package:roll_and_reserve/presentation/screens/user_screen.dart';
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
