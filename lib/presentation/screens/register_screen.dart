import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/functions/validator_function.dart';

import '../blocs/auth/login_state.dart';

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

  final formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  rive.StateMachineController? controller;

  rive.SMIInput<bool>? coverEyes;
  rive.SMIInput<double>? lookNumber;
  rive.SMIInput<bool>? unHide;
  rive.SMIInput<bool>? fly;
  rive.SMIInput<bool>? check;
  rive.SMIInput<bool>? trigger;

  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocused);
    nameFocusNode.addListener(emailFocus);
    confirmPasswordFocusNode.addListener(confirmationPasswordFocused);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocused);
    nameFocusNode.removeListener(emailFocus);
    confirmPasswordFocusNode.removeListener(confirmationPasswordFocused);
    super.dispose();
  }

  void emailFocus() {
    if (emailFocusNode.hasFocus) {
      check?.change(true);
    } else {
      check?.change(false);
    }
  }

  void nameFocus() {
    if (nameFocusNode.hasFocus) {
      check?.change(true);
    } else {
      check?.change(false);
    }
  }

  void passwordFocused() {
    if (passwordFocusNode.hasFocus && !_passwordConfirmVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (passwordFocusNode.hasFocus && _passwordConfirmVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (!passwordFocusNode.hasFocus) {
      coverEyes?.change(false);
      trigger?.change(true);
      check?.change(false);
    }
  }

  void confirmationPasswordFocused() {
    if (confirmPasswordFocusNode.hasFocus && !_passwordVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (confirmPasswordFocusNode.hasFocus && _passwordVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (!confirmPasswordFocusNode.hasFocus) {
      coverEyes?.change(false);
      trigger?.change(true);
      check?.change(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
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
            child: Column(
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
                  'SingIn to continue',
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
                      fly = controller?.findInput<bool>("Fly");
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
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: nameFocusNode,
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              check?.change(true);
                              lookNumber?.change(value.length.toDouble());
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre es obligatorio';
                              }
                              final isNameUsed = loginBloc.state.isNameUsed;
                              if (isNameUsed != null && isNameUsed) {
                                return 'El nombre ya está en uso.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
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
                              check?.change(true);
                              lookNumber?.change(value.length.toDouble());
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'El email es obligatorio';
                              }
                              if (!isEmailValid(value)) {
                                return 'El correo electrónico no es válido';
                              }
                              final isEmailUsed = loginBloc.state.isEmailUsed;
                              if (isEmailUsed != null && isEmailUsed) {
                                return 'El email ya está en uso.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La contraseña es obligatoria';
                              }
                              if (value.length < 8) {
                                return 'La contraseña debe tener al menos 8 caracteres';
                              }
                              if (!hasNumber(value)) {
                                return 'La contraseña debe contener al menos un número';
                              }
                              if (!hasUppercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra mayúscula';
                              }
                              if (!hasLowercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra minúscula';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            focusNode: confirmPasswordFocusNode,
                            controller: confirmPasswordController,
                            obscureText: !_passwordConfirmVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordConfirmVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    unHide?.change(!_passwordConfirmVisible);
                                    _passwordConfirmVisible =
                                        !_passwordConfirmVisible;
                                  });
                                },
                              ),
                              labelText: ' Confirmation Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'La contraseña es obligatoria';
                              }
                              if (value.length < 8) {
                                return 'La contraseña debe tener al menos 8 caracteres';
                              }
                              if (!hasNumber(value)) {
                                return 'La contraseña debe contener al menos un número';
                              }
                              if (!hasUppercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra mayúscula';
                              }
                              if (!hasLowercaseLetter(value)) {
                                return 'La contraseña debe contener al menos una letra minúscula';
                              }
                              if (value != passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: BlocListener<LoginBloc, LoginState>(
                                  listener: (context, state) {
                                    if (state.isEmailUsed != null &&
                                        state.isNameUsed != null) {
                                      if (state.isEmailUsed! ||
                                          state.isNameUsed!) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'El email o nombre ya existe en la base de datos'),
                                          ),
                                        );
                                      }
                                      if (formKey.currentState!.validate()) {
                                        context
                                            .read<LoginBloc>()
                                            .add(RegisterButtonPressed(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              name: nameController.text,
                                            ));
                                        context.go('/login');
                                      }
                                    }
                                  },
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final loginBloc =
                                          context.read<LoginBloc>();
                                      loginBloc.add(IsEmailUserUsed(
                                          email: emailController.text,
                                          name: nameController.text));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6A11CB),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
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
