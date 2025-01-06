import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';

class AppBarDefault extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppBarDefault({super.key, required this.scaffoldKey});

  @override
  State<AppBarDefault> createState() => _AppBarDefaultState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _AppBarDefaultState extends State<AppBarDefault> {
  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(CheckAuthentication());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ClipRRect(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 10,
              shadowColor: Colors.black45,
              centerTitle: true,
              toolbarHeight: 100,
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icon/logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Roll & Reserve',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        "Encuentra tu mesa de juego",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image(
                          width: 60, // Tamaño fijo
                          height: 60,
                          fit: BoxFit.cover,
                          image: kIsWeb
                              ? MemoryImage(state.user!.avatar!)
                              : FileImage(File(state.user!.avatar.path))
                                  as ImageProvider,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/appbar_back.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
