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

  /// Initializes the Firebase Cloud Messaging service.
  ///
  /// This method should be called on app launch. It requests notification
  /// permissions, gets a token for the current device, configures foreground and
  /// opened app notifications, and sets up the onBackgroundMessage handler.
  ///
  /// This method is idempotent, i.e. it's safe to call it multiple times.
  Future<void> initialize() async {
    await requestPermissions();
    await getToken();
    _configureForegroundNotifications();
    _configureOpenedAppNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Requests notification permissions from the user.
  ///
  /// This method displays a permission request dialog to the user, asking for
  /// permission to display notifications. If the user accepts the permission,
  /// [debugPrint]s "Permisos concedidos". If the user denies the permission,
  /// [debugPrint]s "Permisos denegados".
  ///
  /// This method is idempotent, i.e. it's safe to call it multiple times.
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

  /// Gets the current device's FCM token and updates it in the backend.
  ///
  /// This method requests a token from the FCM service, and if the request is
  /// successful, it updates the token in the backend using the
  /// [UserRespository.updateTokenNotification] method.
  ///
  /// If the request fails, it prints an error message. If the token is null,
  /// it prints a message saying that the token could not be obtained.
  ///
  /// This method is idempotent, i.e. it's safe to call it multiple times.
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

  /// Listens for messages received while the app is in the foreground.
  ///
  /// When a message is received, it prints a debug message with the title of
  /// the message, and shows a notification banner with the message's title
  /// and body.
  ///
  /// This method is idempotent, i.e. it's safe to call it multiple times.
  void _configureForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "Mensaje recibido en primer plano: ${message.notification?.title}");
      _showNotificationBanner(message);
    });
  }

  /// Listens for messages that trigger the app to open.
  ///
  /// When a message is received, it prints a debug message with the title of
  /// the message, and if the message contains a 'ruta' key, it navigates to
  /// the specified route.
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
/// Handles messages that are received while the app is in the background.
  ///
  /// Prints a debug message with the title of the message, or "Sin título" if
  /// the title is null.
  ///
  /// This method is called when [FirebaseMessaging.onBackgroundMessage] is
  /// triggered.
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
  
    debugPrint(
        "Mensaje recibido en segundo plano: ${message.notification?.title}");
  }


  /// Shows a notification banner with the title and body of the given message.
  ///
  /// If the message has no title or body, it defaults to "Notificación" and
  /// "Sin contenido", respectively.
  ///
  /// The notification banner is shown using [showDialog] with the context of
  /// the overlay of the current navigator. If the context is null, the method
  /// does nothing.
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

  /// Subscribes the device to the specified shop topic for push notifications.
  ///
  /// This method subscribes the device to a Firebase Cloud Messaging topic
  /// using the given shop ID. Once subscribed, the device can receive
  /// notifications sent to this topic.
  ///
  /// [idShop]: The ID of the shop whose topic the device should subscribe to.
  ///
  /// If the subscription is successful, it prints a debug message indicating
  /// the subscription. If an error occurs during the subscription, it prints
  /// an error message with the details of the error.

  Future<void> subscribeToTopic(int idShop) async {
    try {
      await _firebaseMessaging.subscribeToTopic('$idShop');
      debugPrint('Suscrito al topic $idShop');
    } catch (e) {
      debugPrint('Error al suscribirse al topic: $e');
    }
  }

  /// Unsubscribes the device from the specified shop topic for push
  /// notifications.
  ///
  /// This method unsubscribes the device from a Firebase Cloud Messaging
  /// topic using the given shop ID. Once unsubscribed, the device will not
  /// receive any further notifications sent to this topic.
  ///
  /// [idShop]: The ID of the shop whose topic the device should unsubscribe
  /// from.
  ///
  /// If the unsubscription is successful, it prints a debug message indicating
  /// the unsubscription. If an error occurs during the unsubscription, it
  /// prints an error message with the details of the error.
  Future<void> unsubscribeFromTopic(int idShop) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('$idShop');
      debugPrint('Desuscrito del topic $idShop');
    } catch (e) {
      debugPrint('Error al desuscribirse del topic: $e');
    }
  }

  /// Checks if the device is currently subscribed to the specified shop topic
  /// for push notifications.
  ///
  /// This method retrieves the current FCM topic subscriptions and checks if
  /// the device is currently subscribed to the topic with the name
  /// "shop_<idShop>".
  ///
  /// [idShop]: The ID of the shop whose topic subscription should be checked.
  ///
  /// Returns `true` if the device is subscribed to the topic, `false` otherwise.
  /// If an error occurs during the check, it prints an error message with the
  /// details of the error and returns `false`.
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
