import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/router/routes.dart';
import 'package:roll_and_reserve/firebase_options.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_event.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_state.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/core/services/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// This is the main function of the app. It loads the environment variables
/// from the .env file, removes the splash screen after 2 seconds, initializes
/// Firebase, configures the dependencies, initializes the notification
/// service and runs the app.
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Advertencia: No se pudo cargar el archivo .env ($e).');
  }
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && mounted) {
        var path = uri.path;
        final parameters = uri.queryParameters;
        path = path.replaceAll(RegExp(r'/\d+$'), '');
        router.go(path, extra: parameters);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override

  /// Builds the UI of the app.
  ///
  /// This widget is the root of the app. It provides the BLoCs for the app,
  /// and builds a [MaterialApp] with the router configuration and the
  /// internationalization settings. It also sets the locale of the app
  /// based on the language set in the app.
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LoginBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<LanguageBloc>()..add(GetLocaleEvent()),
        ),
        BlocProvider(
          create: (_) => sl<ShopBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<TableBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ReserveBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<GameBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<EventBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<PlayerBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<AdminUserBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<UserProfileBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ReviewBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ChatBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                title: 'Roll and Reserve',
                theme: AppTheme.lightTheme,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('es'),
                  Locale('fr'),
                  Locale('ca'),
                ],
                locale: state.locale,
              );
            },
          );
        },
      ),
    );
  }
}
