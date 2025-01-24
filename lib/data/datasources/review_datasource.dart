import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/review_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getAllReviews(String token);
  Future<bool> deleteReviews(int idReviews, String token);
  Future<bool> createReviews(ReviewModel review, String token);
}

class ReviewsRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;

  ReviewsRemoteDataSourceImpl(this.client);

  @override
  Future<List<ReviewModel>> getAllReviews(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reviews'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reviewJson = json.decode(response.body);
      return reviewJson.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la reseña.');
    }
  }

  @override
  Future<bool> deleteReviews(int idReviews, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/reviews/$idReviews'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar la reseña.');
    }
  }

  @override
  Future<bool> createReviews(ReviewModel review, String token) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(review.shopReviewToJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al crear la reseña: ${response.body}');
    }
  }
}
