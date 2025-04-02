import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_state.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/input_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogoUserSettings extends StatefulWidget {
  const DialogoUserSettings({super.key});

  @override
  State<DialogoUserSettings> createState() => _DialogoUserSettingsState();
}

class _DialogoUserSettingsState extends State<DialogoUserSettings> {
  late dynamic _imageFile;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _nombreRealController = TextEditingController();

  @override
  /// Initialize the dialog with the information of the user to edit.
  ///
  /// Get the user from the [LoginBloc] with the [idUser] and set the information
  /// of the user in the [TextEditingController]s and the [_imageFile].
  ///
  /// The information of the user is used to fill the form of the dialog.
  void initState() {
    final userBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
    _nombreController.text = userBloc.state.user!.username;
    _nombreRealController.text = userBloc.state.user!.name;
    _imageFile = userBloc.state.user!.avatar;
  }

  @override
  /// Builds the dialog for editing user settings.
  ///
  /// The dialog is a [Dialog] widget with a [BlocBuilder] of the [LoginBloc].
  /// The form of the dialog is a [Form] widget with a [CircleAvatar] to show the
  /// avatar of the user, a [TextDialogInput] to edit the username, a [DropdownButtonFormField]
  /// to select the role, a [TextDialogInput] to edit the name, and two [TextButton]s
  /// to cancel or save the changes.
  ///
  /// When the user selects a new avatar, the [_imageFile] is updated with the new image.
  /// When the user selects a new role, the [_roleController] is updated with the new role.
  /// When the user saves the changes, the [UpdateUserInfoEvent] is added to the [LoginBloc]
  /// with the new user information.
  ///
  /// The dialog is closed when the user cancels or saves the changes.
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                     AppLocalizations.of(context)!.user_settings,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: kIsWeb
                            ? (_imageFile is Uint8List
                                ? MemoryImage(_imageFile)
                                : null)
                            : FileImage(File(_imageFile.path)) as ImageProvider,
                        backgroundColor: Colors.grey[200],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheet(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextDialogInput(
                          controller: _nombreController,
                          labelText:  AppLocalizations.of(context)!.username,
                        ),
                        const SizedBox(height: 12),
                        TextDialogInput(
                          controller: _nombreRealController,
                          labelText:  AppLocalizations.of(context)!.name,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: AppTheme.textButtonCancelStyle,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:  Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        style: AppTheme.textButtonAcceptStyle,
                        onPressed: () {
                          context.read<LoginBloc>().add(
                                UpdateUserInfoEvent(
                                  user: UserEntity(
                                    id: state.user!.id,
                                    username: _nombreController.text,
                                    email: state.user!.email,
                                    avatar: _imageFile,
                                    name: _nombreRealController.text,
                                    averageRaiting: state.user!.averageRaiting,
                                    role: state.user!.role,
                                    notifications: state.user!.notifications,
                                  ),
                                ),
                              );
                          Navigator.pop(context);
                        },
                        child:  Text(AppLocalizations.of(context)!.save),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// A bottom sheet that is shown when the user wants to add a new avatar.
  /// It shows a message that indicates the user can select a new avatar from the gallery or take a photo with the camera.
  /// There are two actions: one to select a new avatar from the gallery and one to take a photo with the camera.
  /// When the user selects an avatar, the [_imageFile] is updated with the new image and the dialog is closed.
  ///
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
         Text(
           AppLocalizations.of(context)!.add_profile_image,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: () {
              takePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
            label:  Text( AppLocalizations.of(context)!.camera),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            icon: const Icon(Icons.image),
            onPressed: () {
              takePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
            label:  Text(
               AppLocalizations.of(context)!.gallery,
            ),
          )
        ])
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          pickedFile.readAsBytes().then((bytes) {
            setState(() {
              _imageFile = bytes;
            });
          });
        } else {
          _imageFile = File(pickedFile.path);
        }
      });
    }
  }
}
