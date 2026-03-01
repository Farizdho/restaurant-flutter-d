import 'package:flutter/material.dart';
import '../data/db/database_helper.dart';
import '../data/model/favorite_restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  FavoriteProvider(this.databaseHelper) {
    loadFavorites();
  }

  List<FavoriteRestaurant> _favorites = [];
  List<FavoriteRestaurant> get favorites => _favorites;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  // ========================
  // LOAD ALL
  // ========================
  Future<void> loadFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    notifyListeners();
  }

  // ========================
  // CHECK FAVORITE
  // ========================
  Future<void> checkFavorite(String id) async {
    final result = await databaseHelper.getFavoriteById(id);
    _isFavorite = result != null;
    notifyListeners();
  }

  // ========================
  // TOGGLE
  // ========================
  Future<void> toggleFavorite(FavoriteRestaurant restaurant) async {
    if (_isFavorite) {
      await databaseHelper.removeFavorite(restaurant.id);
    } else {
      await databaseHelper.insertFavorite(restaurant);
    }

    await checkFavorite(restaurant.id);
    await loadFavorites();
  }
}
