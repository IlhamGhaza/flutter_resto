import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurants() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurants = data['restaurants'];
      return restaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<Restaurant> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Restaurant.fromJson(data['restaurant']);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurants = data['restaurants'];
      return restaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add review');
    }
  }
}
