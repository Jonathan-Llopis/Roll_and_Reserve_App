import 'package:roll_and_reserve/presentation/screens/login_screen.dart';
import 'package:roll_and_reserve/presentation/screens/register_screen.dart';
import 'package:roll_and_reserve/presentation/screens/user_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
   final isLoggedIn = await SharedPreferences.getInstance();
   final email = isLoggedIn.getString('email');
   if ( !state.matchedLocation.contains("/login") && email == null) {
     return '/login';
   } else {
     return state.matchedLocation;
   }
 },
);
