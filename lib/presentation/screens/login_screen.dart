import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/rive_animation.dart';
import 'package:roll_and_reserve/presentation/functions/show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/login_with_google.dart';
import 'package:roll_and_reserve/presentation/widgets/custom_form_field.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/login_button.dart';

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

  RiveAnimationController? riveController;

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
    riveController?.emailFocus(emailFocusNode.hasFocus);
  }

  void passwordFocused() {
    riveController?.passwordFocus(passwordFocusNode.hasFocus, _passwordVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: AppTheme.backgroundDecoration,
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
                const Text('Roll and Reserve', style: AppTheme.titleStyle),
                const SizedBox(height: 10),
                const Text('Login to continue', style: AppTheme.subtitleStyle),
                const SizedBox(height: 30),
                SizedBox(
                  height: 230,
                  width: 400,
                  child: rive.RiveAnimation.asset(
                    "assets/animation/dragon_animations.riv",
                    fit: BoxFit.cover,
                    stateMachines: const ["State Machine 1"],
                    onInit: (artboard) {
                      riveController = RiveAnimationController(artboard);
                      emailFocus();
                      passwordFocused();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.containerDecoration,
                  child: Column(children: [
                    CustomFormField(
                        controller: emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          emailFocus();
                          riveController?.updateLookNumber(value.length);
                        },
                        focusNode: emailFocusNode,
                        riveController: riveController),
                    const SizedBox(height: 15),
                    CustomFormField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      obscureText: !_passwordVisible,
                      onChanged: (value) {
                        passwordFocused();
                      },
                      focusNode: passwordFocusNode,
                      riveController: riveController,
                      sufixIconButton: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                            riveController!.toggleUnHide(_passwordVisible);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: LoginButton(
                              emailController: emailController,
                              passwordController: passwordController),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: LoginWithGoogle(),
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
                    context.push('/login/signIn');
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
