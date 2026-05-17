import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/controller_rive_animation.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_login_google.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/custom_form_field.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_login.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  late DragonRiveController riveController;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void emailFocus() {
    _emailFocusNode.addListener(() {
      riveController.emailFocus(_emailFocusNode.hasFocus);
    });
  }

  void passwordFocused() {
    _passwordFocusNode.addListener(() {
      riveController.passwordFocus(
        _passwordFocusNode.hasFocus,
        isPasswordVisible,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess && state.user != null) {
            context.go('/user');
          } else if (state is LoginFailure) {
            ElegantNotification.error(
              width: 360,
              stackedOptions: StackedOptions(
                key: 'top',
                type: StackedType.same,
                itemOffset: const Offset(0, 5),
              ),
              title: Text(loc.error),
              description: Text(state.message),
              onDismiss: () {},
            ).show(context);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1D1B4B), Color(0xFF111827)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/icon/logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Roll & Reserve',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.login_to_continue,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: rive.RiveAnimation.asset(
                        'assets/animation/dragon_animations.riv',
                        fit: BoxFit.contain,
                        stateMachines: const ['State Machine 1'],
                        onInit: (artboard) {
                          riveController = DragonRiveController(artboard);
                          emailFocus();
                          passwordFocused();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            labelText: loc.email,
                            icon: Icons.email_outlined,
                            onChanged: (value) {
                              riveController.updateLookNumber(value.length);
                            },
                            validator: (value) =>
                                validateEmail(value, loginBloc, context),
                            riveController: riveController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            labelText: loc.password,
                            icon: Icons.lock_outline,
                            obscureText: !isPasswordVisible,
                            sufixIconButton: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                  riveController
                                      .toggleUnHide(isPasswordVisible);
                                });
                              },
                            ),
                            validator: (value) =>
                                validatePassword(value, context),
                            onChanged: (value) {},
                            riveController: riveController,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => mostrarResetPassword(context),
                              child: Text(
                                loc.you_forgot_your_password,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ButtonLogin(
                            emailController: _emailController,
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: Colors.white24),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  loc.or_continue_with,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: Colors.white24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const ButtonLoginGoogle(),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loc.dont_have_an_account_register_here,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () => context.go('/register'),
                                child: Text(
                                  loc.register,
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
