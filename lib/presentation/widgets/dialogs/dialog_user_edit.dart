import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_event.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_state.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_components/text_dialog_input.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreRealController = TextEditingController();

  @override
  void initState() {
    final userBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
    _nombreController.text = userBloc.state.user!.username;
    _emailController.text = userBloc.state.user!.email;
    _nombreRealController.text = userBloc.state.user!.name;
    _imageFile = userBloc.state.user!.avatar;
  }

  @override
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
                  const Text(
                    "Ajustes del Usuario",
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
                          labelText: "Nombre de Usuario",
                        ),
                        const SizedBox(height: 12),
                        TextDialogInput(
                          controller: _nombreRealController,
                          labelText: "Nombre Real",
                        ),
                        const SizedBox(height: 12),
                        TextDialogInput(
                          controller: _emailController,
                          labelText: "Email",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<LoginBloc>().add(
                                UpdateUserInfoEvent(
                                  user: UserEntity(
                                    id: state.user!.id,
                                    username: _nombreController.text,
                                    email: _emailController.text,
                                    avatar: _imageFile,
                                    name: _nombreRealController.text,
                                    averageRaiting: state.user!.averageRaiting,
                                    role: state.user!.role,
                                  ),
                                ),
                              );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Guardar"),
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        const Text(
          "Añade una imagen de perfil",
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
            label: const Text("Cámara"),
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
            label: const Text(
              "Galería",
            ),
          )
        ])
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    // Usamos el picker dependiendo de la plataforma.
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
