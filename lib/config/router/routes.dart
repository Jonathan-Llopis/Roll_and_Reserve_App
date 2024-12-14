// Define the routes using go_router
import 'package:roll_and_reserve/domain/repositories/sign_in_repository.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:roll_and_reserve/presentation/screens/login_page.dart';
import 'package:roll_and_reserve/presentation/screens/user_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(path: '/user', builder: (context, state) => const UserPage()),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
    return isLoggedIn.fold((_) => '/login', (loggedIn) {
      if (loggedIn == "NO_USER" && !state.matchedLocation.contains("/login")) {
        return "/login";
      } else {
        return state.matchedLocation;
      }
    });
  },
);
