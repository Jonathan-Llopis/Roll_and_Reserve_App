import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  StateMachineController? controller;

  SMIInput<bool>? coverEyes;
  SMIInput<double>? lookNumber;
  SMIInput<bool>? unHide;
  SMIInput<bool>? fly;
  SMIInput<bool>? check;
  SMIInput<bool>? trigger;

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
      check?.change(true);
    } else {
      check?.change(false);
    }
  }

  void passwordFocused() {
    if (passwordFocusNode.hasFocus && !_passwordVisible) {
      coverEyes?.change(true);
    } else if (passwordFocusNode.hasFocus && _passwordVisible) {
      coverEyes?.change(true);
    } else if(!passwordFocusNode.hasFocus){
      check?.change(false);
      coverEyes?.change(false);
      trigger?.change(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.email != null && state.email != "NO_USER") {
              context.go('/user', extra: state.email);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                SizedBox(
                    height: 250,
                    child: RiveAnimation.asset(
                      "animation/dragon_animations.riv",
                      fit: BoxFit.fitWidth,
                      stateMachines: const ["State Machine 1"],
                      onInit: (artboard) {
                        controller = StateMachineController.fromArtboard(
                          artboard,
                          "State Machine 1",
                        );
                        if (controller == null) return;
                        artboard.addController(controller!);
                        coverEyes = controller?.findInput<bool>("Cover Eyes");
                        lookNumber = controller?.findInput<double>("Number 1");
                        unHide = controller?.findInput<bool>("Unhide");
                        fly = controller?.findInput<bool>("Fly");
                        check = controller?.findInput<bool>("Check");
                        trigger = controller?.findInput<bool>("Trigger 1");
                        emailFocus();
                        passwordFocused();
                      },
                    )),
                TextField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    lookNumber?.change(value.length.toDouble());
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  focusNode: passwordFocusNode,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          unHide?.change(!_passwordVisible);
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    context.read<LoginBloc>().add(
                          LoginButtonPressed(email: email, password: password),
                        );
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                          LoginGoogle(),
                        );
                  },
                  child: const Text('Login with Google'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
