import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/config/di/di_auth.dart';
import 'package:roll_and_reserve/config/di/di_chat.dart';
import 'package:roll_and_reserve/config/di/di_core.dart';
import 'package:roll_and_reserve/config/di/di_reservations.dart';
import 'package:roll_and_reserve/config/di/di_shops.dart';

final GetIt sl = GetIt.instance;

/// Configures the dependencies of the application.
///
/// Modular registration divided into:
/// - Core: external clients, prefs, token, language
/// - Auth: authentication, users, admin, user profiles
/// - Shops: shops, tables, reviews, metrics
/// - Reservations: reserves, games, categories, difficulties, events, players
/// - Chat: AI chat providers, prompts, and assistants
Future<void> configureDependencies() async {
  await registerCoreDependencies(sl);
  registerAuthDependencies(sl);
  registerShopDependencies(sl);
  registerReservationDependencies(sl);
  registerChatDependencies(sl);
}
