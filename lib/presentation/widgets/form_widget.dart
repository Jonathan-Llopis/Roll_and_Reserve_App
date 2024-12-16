import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/functions/validator_function.dart';
import 'package:rive/rive.dart' as rive;

class FormWidget extends StatefulWidget {
  final rive.StateMachineController? controller;
  final rive.SMIInput<bool>? coverEyes;
  final rive.SMIInput<double>? lookNumber;
  final rive.SMIInput<bool>? unHide;
  final rive.SMIInput<bool>? fly;
  final rive.SMIInput<bool>? check;
  final rive.SMIInput<bool>? trigger;
  const FormWidget(
      {super.key,
      required this.check,
      required this.controller,
      required this.coverEyes,
      required this.lookNumber,
      required this.unHide,
      required this.fly,
      required this.trigger});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

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
      widget.check?.change(true);
    } else {
      widget.check?.change(false);
    }
  }

  void nameFocus() {
    if (nameFocusNode.hasFocus) {
      widget.check?.change(true);
    } else {
      widget.check?.change(false);
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
    return Form(
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
              final loginBloc = BlocProvider.of<LoginBloc>(context);
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
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
                    _passwordConfirmVisible = !_passwordConfirmVisible;
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  // En tu botón onPressed
                  onPressed: () async {
                    final loginBloc = context.read<LoginBloc>();
                    loginBloc.add(IsEmailUsed(email: emailController.text));
                    final currentState = loginBloc.state;
                    if (currentState.isLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text('Verificando email...'),
                          content: Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Por favor, espere...'),
                            ],
                          ),
                        ),
                      );
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      loginBloc.add(RegisterButtonPressed(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                      ));
                      context.go('/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A11CB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
