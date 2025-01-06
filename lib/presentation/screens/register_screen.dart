import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/rive_animation.dart';
import 'package:roll_and_reserve/presentation/functions/validator_function.dart';
import 'package:roll_and_reserve/presentation/widgets/custom_form_field.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/register_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();

  RiveAnimationController? riveController;

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocused);
    nameFocusNode.addListener(emailFocus);
    confirmPasswordFocusNode.addListener(confirmationPasswordFocused);
    userNameFocusNode.addListener(userNameFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocused);
    nameFocusNode.removeListener(emailFocus);
    confirmPasswordFocusNode.removeListener(confirmationPasswordFocused);
    userNameFocusNode.removeListener(userNameFocus);
    super.dispose();
  }

  void emailFocus() {
    riveController?.emailFocus(emailFocusNode.hasFocus);
  }

  void nameFocus() {
    riveController?.nameFocus(nameFocusNode.hasFocus);
  }
   void userNameFocus() {
    riveController?.nameFocus(nameFocusNode.hasFocus);
  }

  void passwordFocused() {
    riveController?.passwordFocus(passwordFocusNode.hasFocus, _passwordVisible);
  }

  void confirmationPasswordFocused() {
    riveController?.confirmationPasswordFocused(
        confirmPasswordFocusNode.hasFocus, _passwordConfirmVisible);
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppTheme.backgroundDecoration,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Roll and Reserve',
                  style: AppTheme.titleStyle,
                ),
                const SizedBox(height: 10),
                const Text('SingIn to continue', style: AppTheme.subtitleStyle),
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
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomFormField(
                              controller: userNameController,
                              labelText: 'Nombre de Usuario',
                              icon: Icons.badge_rounded,
                              validator: (value) => validateUserName(value, loginBloc),
                              onChanged: (value) {
                                nameFocus();
                                riveController?.updateLookNumber(value.length);
                              },
                              focusNode: userNameFocusNode,
                              riveController: null),
                               const SizedBox(height: 20),
                              CustomFormField(
                              controller: nameController,
                              labelText: 'Nombre',
                              icon: Icons.person,
                              validator: (value) => validateName(value),
                              onChanged: (value) {
                                nameFocus();
                                riveController?.updateLookNumber(value.length);
                              },
                              focusNode: nameFocusNode,
                              riveController: null),
                          const SizedBox(height: 20),
                          CustomFormField(
                              controller: emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                              validator: (value) =>
                                  validateEmail(value, loginBloc),
                              onChanged: (value) {
                                emailFocus();
                                riveController?.updateLookNumber(value.length);
                              },
                              focusNode: emailFocusNode,
                              riveController: null),
                          const SizedBox(height: 20),
                          CustomFormField(
                            controller: passwordController,
                            labelText: 'Password',
                            icon: Icons.lock,
                            validator: (value) => validatePassword(value),
                            obscureText: !_passwordVisible,
                            focusNode: passwordFocusNode,
                            onChanged: (String value) {},
                            riveController: null,
                            sufixIconButton: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                  riveController!
                                      .toggleUnHide(_passwordVisible);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomFormField(
                            controller: confirmPasswordController,
                            labelText: 'Confirmation Password',
                            icon: Icons.lock,
                            validator: (value) => validateConfirmPassword(
                                value, passwordController),
                            obscureText: !_passwordConfirmVisible,
                            focusNode: confirmPasswordFocusNode,
                            onChanged: (String value) {},
                            riveController: null,
                            sufixIconButton: IconButton(
                              icon: Icon(
                                _passwordConfirmVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordConfirmVisible =
                                      !_passwordConfirmVisible;
                                  riveController!
                                      .toggleUnHide(_passwordConfirmVisible);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  style: AppTheme.elevatedButtonCancelStyle,
                                  child: const Text('Cancelar',
                                      style: AppTheme.buttonStyle),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: RegisterButton(
                                    formKey: formKey,
                                    emailController: emailController,
                                    passwordController: passwordController,
                                    nameController: nameController,
                                    userNameController: userNameController),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
