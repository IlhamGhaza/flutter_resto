import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

enum ResultState { loading, hasData, error, noData }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  List<Restaurant> _restaurants = [];
  Restaurant? _selectedRestaurant;
  ResultState _state = ResultState.loading;
  String _message = '';

  RestaurantProvider({required this.apiService});

  List<Restaurant> get restaurants => _restaurants;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  ResultState get state => _state;
  String get message => _message;

  Future<void> fetchRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _restaurants = await apiService.getRestaurants();
      _state = _restaurants.isEmpty ? ResultState.noData : ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      debugPrint(message);
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _selectedRestaurant = await apiService.getRestaurantDetail(id);
      _state = ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      debugPrint(message);
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      _restaurants = await apiService.searchRestaurants(query);
      _state = _restaurants.isEmpty ? ResultState.noData : ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      debugPrint(message);
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      await apiService.addReview(id: id, name: name, review: review);
      await fetchRestaurantDetail(id);
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      debugPrint(message);
      notifyListeners();
    }
  }
}
