import 'customer_review.dart';

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> customerReviews; // ⭐ TAMBAHAN

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.foods,
    required this.drinks,
    required this.customerReviews, // ⭐ TAMBAHAN
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final foodsJson = json['menus']?['foods'] as List<dynamic>? ?? [];
    final drinksJson = json['menus']?['drinks'] as List<dynamic>? ?? [];
    final reviewsJson = json['customerReviews'] as List<dynamic>? ?? [];

    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '-',
      description: json['description'] ?? '',
      city: json['city'] ?? '-',
      address: json['address'] ?? '-',
      pictureId: json['pictureId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      foods: foodsJson.map((e) => e['name'] as String).toList(),
      drinks: drinksJson.map((e) => e['name'] as String).toList(),
      customerReviews: reviewsJson
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}
