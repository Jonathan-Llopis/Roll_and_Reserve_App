import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/router/routes.dart';
import 'package:roll_and_reserve/firebase_options.dart';
import 'package:roll_and_reserve/injection.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Roll and Reserve',
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
