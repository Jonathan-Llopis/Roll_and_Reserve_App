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
  /// Fetches all reviews from the remote server.
  ///
  /// The [token] is the access token for authorization.
  ///
  /// Returns a [Future] that resolves to a list of [ReviewModel] if the request
  /// is successful.
  ///
  /// Throws an [Exception] if the request fails.

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
  /// Deletes a review from the remote server.
  ///
  /// The [idReviews] is the id of the review to delete.
  /// The [token] is the access token for authorization.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the review was deleted.
  /// Throws an [Exception] if there is an error during the deletion process.
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
  /// Creates a review on the remote server.
  ///
  /// The [review] parameter is a [ReviewModel] object containing the data of the review to be created.
  /// The [token] is the access token for authorization.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 201, returns true indicating the review was created.
  /// Throws an [Exception] if there is an error during the creation process.

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
