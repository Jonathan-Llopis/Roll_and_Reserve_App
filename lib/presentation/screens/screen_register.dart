import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/functions/controller_rive_animation.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_register.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/custom_form_field.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  late DragonRiveController riveController;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _usernameFocusNode.dispose();
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
    _confirmPasswordFocusNode.addListener(() {
      riveController.confirmationPasswordFocused(
        _confirmPasswordFocusNode.hasFocus,
        isConfirmPasswordVisible,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.go('/login'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.go('/login');
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 80, bottom: 40),
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
                  children: [
                    Text(
                      loc.create_account,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.fill_details,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
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
                            controller: _nameController,
                            labelText: loc.full_name,
                            icon: Icons.person_outline,
                            validator: (value) => validateName(value, context),
                            onChanged: (value) {},
                            focusNode: FocusNode(),
                            riveController: riveController,
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            controller: _usernameController,
                            focusNode: _usernameFocusNode,
                            labelText: loc.username,
                            icon: Icons.alternate_email,
                            validator: (value) =>
                                validateUserName(value, loginBloc, context),
                            onChanged: (value) {},
                            riveController: riveController,
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          CustomFormField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            labelText: loc.confirmation_password,
                            icon: Icons.lock_clock_outlined,
                            obscureText: !isConfirmPasswordVisible,
                            sufixIconButton: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) => validateConfirmPassword(
                                value, _passwordController, context,),
                            onChanged: (value) {},
                            riveController: riveController,
                          ),
                          const SizedBox(height: 32),
                          ButtonRegister(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            nameController: _nameController,
                            userNameController: _usernameController,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loc.already_have_account,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: Text(
                                  loc.login,
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
