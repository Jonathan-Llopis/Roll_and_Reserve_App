// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogCreateReview extends StatefulWidget {
  final int? idShop;
  final String? idUser;
  final ReviewBloc reviewBloc;
  const DialogCreateReview({
    super.key,
    this.idShop,
    this.idUser,
    required this.reviewBloc,
  });

  @override
  State<DialogCreateReview> createState() => _DialogCreateReviewState();
}

class _DialogCreateReviewState extends State<DialogCreateReview> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  int _rating = 1;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        AppLocalizations.of(context)!.add_review,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.description,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .please_write_a_description;
                  }
                  return null;
                },
                onChanged: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.rating,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int value = index + 1;
                  return Row(
                    children: [
                      Radio<int>(
                        value: value,
                        groupValue: _rating,
                        onChanged: (int? newValue) {
                          setState(() {
                            _rating = newValue!;
                          });
                        },
                      ),
                      Text('$value'),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
              if (widget.idShop != null && widget.idShop != 0) {
                widget.reviewBloc.add(CreateReviewEvent(
                    review: ReviewEntity(
                        id: 0,
                        raiting: _rating,
                        review: _descriptionController.text,
                        writerId: loginBloc.state.user!.id,
                        reviewedId: "",
                        shopReview: widget.idShop!,
                        userNameWriter: '',
                        avatarIdWriter: '',
                        avatarWriter: [])));
                context.read<ShopBloc>().add(GetShopsEvent());
                context
                    .read<ShopBloc>()
                    .add(GetShopEvent(idShop: widget.idShop!));
              }else if(widget.idUser != null){
                 widget.reviewBloc.add(CreateReviewEvent(
                    review: ReviewEntity(
                        id: 0,
                        raiting: _rating,
                        review: _descriptionController.text,
                        writerId: loginBloc.state.user!.id,
                        reviewedId: widget.idUser!,
                        shopReview: 0,
                        userNameWriter: '',
                        avatarIdWriter: '',
                        avatarWriter: [])));
                context.read<ReserveBloc>().add(GetLastTenPlayersEvent(idGoogle: loginBloc.state.user!.id));
              }
              Navigator.pop(context);
            }
          },
          child: Text(AppLocalizations.of(context)!.add_review),
        ),
      ],
    );
  }
}
