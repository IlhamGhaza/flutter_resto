import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/list'));

      // debugPrint('Response status: ${response.statusCode}');
      // debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response body');
        }

        final Map<String, dynamic> data = json.decode(responseBody);

        // Check if restaurants key exists and is not null
        if (data['restaurants'] == null) {
          throw Exception('Restaurants data is null');
        }

        final List<dynamic> restaurants = data['restaurants'];
        return restaurants
            .map((restaurant) {
              if (restaurant == null) {
                debugPrint('Warning: Null restaurant object found');
                return null;
              }
              try {
                return Restaurant.fromJson(restaurant as Map<String, dynamic>);
              } catch (e) {
                debugPrint('Error parsing restaurant: $e');
                return null;
              }
            })
            .where((restaurant) => restaurant != null)
            .cast<Restaurant>()
            .toList();
      } else {
        throw Exception(
          'Failed to load restaurants. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in getRestaurants: $e');
      throw Exception('Failed to load restaurants: $e');
    }
  }

  Future<Restaurant> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

      debugPrint('Detail response status: ${response.statusCode}');
      debugPrint('Detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response body');
        }

        final Map<String, dynamic> data = json.decode(responseBody);

        // Check if restaurant key exists and is not null
        if (data['restaurant'] == null) {
          throw Exception('Restaurant data is null');
        }

        return Restaurant.fromJson(data['restaurant'] as Map<String, dynamic>);
      } else {
        throw Exception(
          'Failed to load restaurant detail. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in getRestaurantDetail: $e');
      throw Exception('Failed to load restaurant detail: $e');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

      debugPrint('Search response status: ${response.statusCode}');
      debugPrint('Search response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response body');
        }

        final Map<String, dynamic> data = json.decode(responseBody);

        // Check if restaurants key exists and is not null
        if (data['restaurants'] == null) {
          throw Exception('Search results are null');
        }

        final List<dynamic> restaurants = data['restaurants'];
        return restaurants
            .map((restaurant) {
              if (restaurant == null) {
                debugPrint('Warning: Null restaurant object found in search');
                return null;
              }
              try {
                return Restaurant.fromJson(restaurant as Map<String, dynamic>);
              } catch (e) {
                debugPrint('Error parsing restaurant in search: $e');
                return null;
              }
            })
            .where((restaurant) => restaurant != null)
            .cast<Restaurant>()
            .toList();
      } else {
        throw Exception(
          'Failed to search restaurants. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in searchRestaurants: $e');
      throw Exception('Failed to search restaurants: $e');
    }
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'name': name, 'review': review}),
      );

      debugPrint('Add review response status: ${response.statusCode}');
      debugPrint('Add review response body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to add review. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in addReview: $e');
      throw Exception('Failed to add review: $e');
    }
  }
}
