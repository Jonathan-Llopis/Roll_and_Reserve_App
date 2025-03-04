import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:roll_and_reserve/config/router/routes.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:roll_and_reserve/main.dart';
import 'package:roll_and_reserve/injection.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    await requestPermissions();
    await getToken();
    _configureForegroundNotifications();
    _configureOpenedAppNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permisos concedidos');
    } else {
      debugPrint('Permisos denegados');
    }
  }

  Future<void> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        final sharedPreferences = await SharedPreferences.getInstance();
        final id = sharedPreferences.getString('id');
        final updateToken =
            await di.sl<UserRespository>().updateTokenNotification(id!, token);
        updateToken.fold(
          (failure) => debugPrint("Error al actualizar el token: $failure"),
          (success) => debugPrint("Token de FCM: $token"),
        );
      } else {
        debugPrint("No se pudo obtener el token.");
      }
    } catch (e) {
      debugPrint("Error al obtener el token: $e");
    }
  }

  void _configureForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje recibido en primer plano: ${message.notification?.title}");
      _showNotificationBanner(message);
    });
  }

  void _configureOpenedAppNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          "La app se abrió desde la notificación: ${message.notification?.title}");

      if (message.data.containsKey('ruta')) {
        String ruta = message.data['ruta'];
        router.go(ruta);
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        "Mensaje recibido en segundo plano: ${message.notification?.title}");
  }

  void _showNotificationBanner(RemoteMessage message) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title ?? "Notificación"),
            content: Text(message.notification?.body ?? "Sin contenido"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> subscribeToTopic(int idShop) async {
    try {
      await _firebaseMessaging.subscribeToTopic('$idShop');
      debugPrint('Suscrito al topic $idShop');
    } catch (e) {
      debugPrint('Error al suscribirse al topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(int idShop) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('$idShop');
      debugPrint('Desuscrito del topic $idShop');
    } catch (e) {
      debugPrint('Error al desuscribirse del topic: $e');
    }
  }

  Future<bool> checkSubscriptionStatus(int idShop) async {
    try {
      final topics = await _firebaseMessaging.getInitialMessage();
      if (topics != null && topics.data.containsKey('$idShop')) {
        debugPrint('Actualmente suscrito al topic shop_$idShop');
        return true;
      } else {
        debugPrint('No suscrito al topic $idShop');
        return false;
      }
    } catch (e) {
      debugPrint('Error al verificar la suscripción al topic: $e');
      return false;
    }
  }
}
