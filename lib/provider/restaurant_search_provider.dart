import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../utils/result_state.dart';
import '../data/model/restaurant_list_response.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider(this.apiService);

  ResultState state = NoDataState('Masukkan kata kunci');
  RestaurantListResponse? result;

  Future<void> search(String query) async {
    try {
      state = LoadingState();
      notifyListeners();

      final data = await apiService.searchRestaurant(query);

      if (data.restaurants.isEmpty) {
        state = NoDataState('Tidak ada hasil');
      } else {
        state = HasDataState(data);
        result = data;
      }
    } catch (e) {
      state = ErrorState(e.toString());
    }

    notifyListeners();
  }
}
