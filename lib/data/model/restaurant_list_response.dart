import 'restaurant.dart';

class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    final List restaurantsJson = json['restaurants'] ?? [];

    return RestaurantListResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? json['founded'] ?? 0,
      restaurants: restaurantsJson
          .map<Restaurant>((e) => Restaurant.fromJson(e))
          .toList(),
    );
  }
}
