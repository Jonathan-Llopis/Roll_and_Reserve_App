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
  final _descriptionController = TextEditingController();
  int _rating = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
    ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.add_review,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                minLines: 3,
                decoration: InputDecoration(
                  labelText: loc.description,
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                ),
                validator: (value) => value?.isEmpty ?? true 
                    ? loc.please_write_a_description 
                    : null,
              ),
              const SizedBox(height: 28),
      
              Text(
                loc.rating,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              
              StarRating(
                rating: _rating,
                onRatingChanged: (rating) => setState(() => _rating = rating),
                starSize: 36,
              ),
              const SizedBox(height: 24),
      
              _buildSubmitButton(theme, loc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme, AppLocalizations loc) {
    final loc = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      icon: _isSubmitting 
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,

              ),
            )
          : const Icon(Icons.reviews_outlined, size: 20),
      label: Text(_isSubmitting ? AppLocalizations.of(context)!.loading : loc.add_review),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _isSubmitting ? null : _submitReview,
    );
  }

  void _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    try {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      final user = loginBloc.state.user!;
      
      final review = ReviewEntity(
        id: 0,
        raiting: _rating,
        review: _descriptionController.text.trim(),
        writerId: user.id,
        reviewedId: widget.idUser ?? '',
        shopReview: widget.idShop ?? 0,
        userNameWriter: user.name,
        avatarIdWriter: '',
        avatarWriter: user.avatar,
      );

      widget.reviewBloc.add(CreateReviewEvent(review: review));

      if (widget.idShop != null) {
        context.read<ShopBloc>()
          ..add(GetShopsEvent())
          ..add(GetShopEvent(idShop: widget.idShop!));
      } else {
        context.read<ReserveBloc>()
          .add(GetLastTenPlayersEvent(idGoogle: user.id));
      }

      if (mounted) Navigator.pop(context);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final double starSize;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 24,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector( 
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: starSize,
              color: color,
            ),
          ),
        );
      }),
    );
  }
}