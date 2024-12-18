import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/show_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  rive.StateMachineController? controller;

  rive.SMIInput<bool>? coverEyes;
  rive.SMIInput<double>? lookNumber;
  rive.SMIInput<bool>? unHide;
  rive.SMIInput<bool>? check;
  rive.SMIInput<bool>? trigger;

  bool _passwordVisible = false;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocused);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocused);
    super.dispose();
  }

  void emailFocus() {
    if (emailFocusNode.hasFocus) {
      trigger?.change(true);
      check?.change(true);
    } else {
      trigger?.change(true);
      check?.change(false);
    }
  }

  void passwordFocused() {
    if (passwordFocusNode.hasFocus && _passwordVisible) {
      trigger?.change(true);
      coverEyes?.change(true);
    } else if (passwordFocusNode.hasFocus && !_passwordVisible) {
      trigger?.change(true);
      coverEyes?.change(true);
    } else {
      coverEyes?.change(false);
      trigger?.change(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A11CB),
            Color(0xFF2575FC),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child:
              BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.email != null && state.email != "NO_USER") {
              context.go('/user', extra: state.email);
            }
          }, builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Roll and Reserve',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 230,
                  width: 400,
                  child: rive.RiveAnimation.asset(
                    "assets/animation/dragon_animations.riv",
                    fit: BoxFit.cover,
                    stateMachines: const ["State Machine 1"],
                    onInit: (artboard) {
                      controller = rive.StateMachineController.fromArtboard(
                        artboard,
                        "State Machine 1",
                      );
                      if (controller == null) return;
                      artboard.addController(controller!);
                      coverEyes = controller?.findInput<bool>("Cover Eyes");
                      lookNumber = controller?.findInput<double>("Number 1");
                      unHide = controller?.findInput<bool>("Unhide");
                      check = controller?.findInput<bool>("Check");
                      trigger = controller?.findInput<bool>("Trigger 1");
                      emailFocus();
                      passwordFocused();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    TextField(
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        emailFocus();
                        lookNumber?.change(value.length.toDouble());
                      },
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              unHide?.change(!_passwordVisible);
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A11CB),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              context.read<LoginBloc>().add(
                                    LoginButtonPressed(
                                        email: email, password: password),
                                  );
                              if (state.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage!)),
                                );
                              }
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black12),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                    LoginGoogle(),
                                  );
                              if (state.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage!)),
                                );
                              }
                            },
                            icon: Image.asset(
                                'assets/images/google.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover),
                            label: const Text(
                              'Google Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    mostrarResetPassword(context);
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  child: const Text(
                    'You forgot your password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    context.push('/login/singIn');
                  },
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ));
  }
}
