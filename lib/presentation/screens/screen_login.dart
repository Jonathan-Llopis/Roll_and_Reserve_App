import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_login.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  RiveAnimationController? riveController;

  bool _passwordVisible = false;

  @override
  /// Adds the [emailFocus] and [passwordFocused] functions to the
  /// [emailFocusNode] and [passwordFocusNode] focus nodes.
  ///
  /// This is done so that the [emailFocus] and [passwordFocused] functions
  /// are called whenever the focus of the [emailFocusNode] or
  /// [passwordFocusNode] changes.
  ///
  /// This is used to control the visibility of the password text field.
  ///
  /// The [super.initState] method is called last to ensure that the
  /// [emailFocusNode] and [passwordFocusNode] are properly initialized.
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocused);

    super.initState();
  }

  @override
  /// Called when the widget is removed from the tree permanently.
  ///
  /// This is the opposite of [initState]. It is called when the widget is
  /// discarded, and is used to free up any resources that aren't needed
  /// anymore.
  ///
  /// In this case, it is used to remove the focus node from the widget tree.
  ///
  /// This method is called automatically when the widget is removed from the
  /// tree, but it is also safe to call manually if you want to prematurely
  /// release resources.
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocused);
    super.dispose();
  }

  /// Calls [riveController?.emailFocus] with the current focus state of the
  /// [emailFocusNode].
  ///
  /// This is used to control the visibility of the email text field.
  ///
  /// The [riveController?.emailFocus] method is called only if the
  /// [riveController] is not null, and the [emailFocusNode] is not null.
  void emailFocus() {
    riveController?.emailFocus(emailFocusNode.hasFocus);
  }

  /// Calls [riveController?.passwordFocus] with the current focus state of the
  /// [passwordFocusNode] and the current state of the [_passwordVisible].
  ///
  /// This is used to control the visibility of the password text field.
  ///
  /// The [riveController?.passwordFocus] method is called only if the
  /// [riveController] is not null, and the [passwordFocusNode] is not null.
  void passwordFocused() {
    riveController?.passwordFocus(passwordFocusNode.hasFocus, _passwordVisible);
  }

  @override
    /// Builds the login screen.
  ///
  /// This screen is used to login to the app. It shows the
  /// conversation history at the top and an input field at the bottom.
  ///
  /// The title of the screen is "Describe your move" and it shows a restart
  /// icon in the actions section that restarts the conversation when pressed.
  ///
  /// The input field is an [InputTextImage] widget that allows the user to
  /// input text and images. The focus node is passed as a parameter so that
  /// the input field can request focus when the user starts typing.
  ///
  /// The conversation history is a [BodyMessages] widget that shows the
  /// conversation history. It is passed the [ChatBloc] as a parameter so that
  /// it can retrieve the messages from the bloc.
  ///
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6A11CB),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        endDrawer: const DrawerLogin(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppTheme.backgroundDecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.errorMessage != null && state.email != null) {
                    ElegantNotification.error(
                      width: 360,
                      isDismissable: false,
                      stackedOptions: StackedOptions(
                        key: 'bottomRight',
                        type: StackedType.above,
                        itemOffset: const Offset(-5, -5),
                      ),
                      title: Text(state.errorMessage!),
                      description: Text(AppLocalizations.of(context)!
                          .user_or_password_incorrect),
                    ).show(context);
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.email != null && state.email != "NO_USER") {
                    context.go('/user', extra: state.email);

                    return const SizedBox.shrink();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Roll and Reserve',
                            style: AppTheme.titleStyle),
                        const SizedBox(height: 10),
                        Text(AppLocalizations.of(context)!.login,
                            style: AppTheme.subtitleStyle),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 230,
                          width: 400,
                          child: rive.RiveAnimation.asset(
                            "assets/animation/dragon_animations.riv",
                            fit: BoxFit.cover,
                            stateMachines: const ["State Machine 1"],
                            onInit: (artboard) {
                              riveController =
                                  RiveAnimationController(artboard);
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
                                labelText: AppLocalizations.of(context)!.email,
                                icon: Icons.email,
                                validator: validateEmail,
                                onChanged: (value) {
                                  emailFocus();
                                  riveController
                                      ?.updateLookNumber(value.length);
                                },
                                focusNode: emailFocusNode,
                                riveController: riveController),
                            const SizedBox(height: 15),
                            CustomFormField(
                              controller: passwordController,
                              labelText: AppLocalizations.of(context)!.password,
                              icon: Icons.lock,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .please_enter_your_password;
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
                                    riveController!
                                        .toggleUnHide(_passwordVisible);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ButtonLogin(
                                      emailController: emailController,
                                      passwordController: passwordController),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: ButtonLoginGoogle(),
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
                          child: Text(
                            AppLocalizations.of(context)!
                                .you_forgot_your_password,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            context.push('/login/signIn');
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .dont_have_an_account_register_here,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
