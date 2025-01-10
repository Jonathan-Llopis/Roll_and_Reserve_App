import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/shop_add_table.dart';
import 'package:roll_and_reserve/presentation/widgets/buttons/button_cu_shop.dart';

class EditStoreForm extends StatefulWidget {
  final int? idShop;
  const EditStoreForm({super.key, this.idShop});

  @override
  State<EditStoreForm> createState() => _EditStoreFormState();
}

class _EditStoreFormState extends State<EditStoreForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  late dynamic _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final shopBloc = BlocProvider.of<ShopBloc>(context);
    context
        .read<TableBloc>()
        .add(GetTablesByShopEvent(idShop: widget.idShop!));
    if (widget.idShop != 0) {
      ShopEntity shopEdit =
          shopBloc.state.shops!.firstWhere((shop) => shop.id == widget.idShop);
      _titleController.text = shopEdit.name;
      _adressController.text = shopEdit.address;
      _imageFile = shopEdit.logo;
    } else {
      _titleController.text = '';
      _adressController.text = '';
      _imageFile = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.tables != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Editar Tienda'),
              backgroundColor: Colors.teal,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
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
                                : FileImage(File(_imageFile.path))
                                    as ImageProvider,
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
                        labelText: 'Título',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _adressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La dirección es obligatoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    widget.idShop != 0
                        ? AddTables(
                            widget: widget,
                            state: state,
                          )
                        : Container(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            context.go('/user');
                          },
                          icon: Icon(Icons.cancel),
                          label: Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                        ),
                        CreateUpdateShop(
                          titleController: _titleController,
                          adressController: _adressController,
                          imageFile: _imageFile,
                          idShop: widget.idShop!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    widget.idShop == 0
                        ? Container()
                        : Center(
                            child: TextButton(
                              onPressed: () {
                                deleteShop(context, widget.idShop!);
                              },
                              child: Text('Eliminar tienda',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
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
