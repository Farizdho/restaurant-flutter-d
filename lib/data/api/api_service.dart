import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/restaurant_list_response.dart';
import '../model/restaurant_detail_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantListResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurant');
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
