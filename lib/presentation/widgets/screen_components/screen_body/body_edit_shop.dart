import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roll_and_reserve/config/theme/theme.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_validation.dart';
import 'package:roll_and_reserve/presentation/screens/screen_edit_shop.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/map_picker.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_cu_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyEditShop extends StatefulWidget {
  const BodyEditShop(
      {super.key,
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

  @override
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
  Widget build(BuildContext context) {
    final shopBloc = BlocProvider.of<ShopBloc>(context);
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
