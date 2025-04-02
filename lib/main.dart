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
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:roll_and_reserve/presentation/functions/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  /// This is the main function of the app. It loads the environment variables
  /// from the .env file, removes the splash screen after 2 seconds, initializes
  /// Firebase, configures the dependencies, initializes the notification
  /// service and runs the app.
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  await NotificationService().initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AppLinks _appLinks;

  @override
  /// Initializes the state of the widget.
  ///
  /// This is called when the widget is inserted into the tree. It initializes
  /// the deep link listener.
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  /// Initializes the deep link listener.
  ///
  /// This function is called when the widget is initialized. It creates an
  /// instance of [AppLinks] and listens to the [uriLinkStream]. When a URI is
  /// received, it extracts the path and parameters from the URI and navigates
  /// to the path using [router.go].
  void _initDeepLinkListener() async {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        var path = uri.path;
        final parameters = uri.queryParameters;
        path = path.replaceAll(RegExp(r'/\d+$'), '');
        router.go(path, extra: parameters);
      }
    });
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
          create: (_) => sl<LanguageBloc>(),
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
          create: (_) => sl<ReviewBloc>(),
        ),
       BlocProvider(
          create: (_) => sl<ChatBloc>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          context.read<LanguageBloc>().add(GetLocaleEvent());
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'Roll and Reserve',
            theme: ThemeData(primarySwatch: Colors.blue),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
              Locale('ca'),
            ],
            locale: state.locale,
          );
        },
      ),
    );
  }
}
