import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/screens/screen_edit_shop.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/map_picker.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_cu_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/user_avatar.dart';

class BodyEditShop extends StatefulWidget {
  const BodyEditShop({
    super.key,
    required this.idShop,
    required this.widget,
  });
  final int? idShop;
  final ScreenEditShop widget;

  @override
  State<BodyEditShop> createState() => _BodyEditShopState();
}

class _BodyEditShopState extends State<BodyEditShop> {
  final _formKey = GlobalKey<FormState>();
  late dynamic _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _idUserController = TextEditingController();

  @override
/// Initializes the state of the `_BodyEditShopState` widget.
///
/// This method is responsible for setting initial values for the form fields
/// based on the shop data. If the `idShop` is not zero, it retrieves the 
/// shop details from the `ShopBloc` state and populates the form fields with 
/// the shop's name, address, latitude, longitude, logo, and owner ID. If the 
/// `idShop` is zero, it sets default values for a new shop entry. Calls 
/// `super.initState()` at the end.

  void initState() {
    final shopBloc = BlocProvider.of<ShopBloc>(context);
    if (widget.idShop != 0) {
      ShopEntity shopEdit =
          shopBloc.state.shops!.firstWhere((shop) => shop.id == widget.idShop);
      _titleController.text = shopEdit.name;
      _adressController.text = shopEdit.address;
      _latitudController.text =
          shopEdit.latitude == 0 ? "0" : shopEdit.latitude.toString();
      _longitudController.text =
          shopEdit.longitude == 0 ? "0" : shopEdit.longitude.toString();
      _imageFile = shopEdit.logo;
      _idUserController.text = shopEdit.ownerId;
    } else {
      _titleController.text = '';
      _adressController.text = '';
      _imageFile = null;
      _latitudController.text = "0";
      _longitudController.text = "0";
    }
    super.initState();
  }

  @override
  /// Builds the body of the shop edition screen.
  ///
  /// This widget is a [SingleChildScrollView] with a [Form] as child.
  /// The [Form] is composed of a [CircleAvatar] with the shop's logo,
  /// a [TextFormField] for the shop's name, a [DropdownButtonFormField]
  /// for selecting the owner of the shop, a [TextFormField] for the
  /// shop's direction, a [LocationPicker] for selecting the shop's
  /// location, and two [TextButton] for cancelling and creating the shop.
  /// The [TextButton] with the cancel label is used to pop the screen,
  /// and the [ButtonCreateUpdateShop] is used to create or update the shop.
  /// If the [idShop] is not zero, a [TextButton] with the delete label is
  /// shown at the bottom of the screen. This button is used to delete the
  /// shop.
  Widget build(BuildContext context) {
    final shopBloc = BlocProvider.of<ShopBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: kIsWeb
                        ? (_imageFile is Uint8List
                            ? MemoryImage(_imageFile)
                            : null)
                        : _imageFile != null
                            ? FileImage(File(_imageFile.path))
                            : null,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.shop_name_text,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => basicValidation(value, context)),
            const SizedBox(height: 16),
            if (loginBloc.state.user!.role == 0)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.select_user,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                items: loginBloc.state.users!
                    .where((user) => user.role == 1)
                    .map((user) {
                  return DropdownMenuItem<String>(
                    value: user.id,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserAvatar(user: user),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  _idUserController.text = value!;
                },
                validator: (value) {
                  if (value == null) {
                    return AppLocalizations.of(context)!.error_select_user;
                  }
                  return null;
                },
              ),
            const SizedBox(height: 16),
            TextFormField(
                controller: _adressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.shop_direction,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => basicValidation(value, context)),
            const SizedBox(height: 16),
            LocationPicker(
              latitudeController: _latitudController,
              longitudeController: _longitudController,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context.go('/user');
                  },
                  style: AppTheme.textButtonCancelStyle,
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                ButtonCreateUpdateShop(
                  titleController: _titleController,
                  adressController: _adressController,
                  imageFile: _imageFile,
                  idShop: widget.idShop!,
                  longitudController: _longitudController,
                  latitudController: _latitudController,
                  idUserController: _idUserController,
                ),
              ],
            ),
            const SizedBox(height: 24),
            widget.idShop == 0
                ? Container()
                : Center(
                    child: TextButton.icon(
                      style: AppTheme.textButtonCancelStyle,
                      onPressed: () {
                        deleteShop(context, widget.idShop!, shopBloc);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                      label: Text(AppLocalizations.of(context)!.shop_delete,
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// A bottom sheet that is shown when the user wants to add a new avatar.
  /// It shows a message that indicates the user can select a new avatar from the gallery or take a photo with the camera.
  /// There are two actions: one to select a new avatar from the gallery and one to take a photo with the camera.
  /// When the user selects an avatar, the [_imageFile] is updated with the new image and the dialog is closed.
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
            label: Text(AppLocalizations.of(context)!.camera),
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
            label: Text(
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
