// Define the routes using go_router
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:roll_and_reserve/presentation/screens/login_screen.dart';
import 'package:roll_and_reserve/presentation/screens/register_screen.dart';
import 'package:roll_and_reserve/presentation/screens/user_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/singIn',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/user', builder: (context, state) => const UserScreen()),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<LoginRepository>().isLoggedIn();
    return isLoggedIn.fold((_) => '/login', (loggedIn) {
      if (loggedIn == "NO_USER" && !state.matchedLocation.contains("/login")) {
        return "/login";
      } else {
        return state.matchedLocation;
      }
    });
  },
);
