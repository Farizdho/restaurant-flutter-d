import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../utils/result_state.dart';
import '../data/model/restaurant_list_response.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider(this.apiService);

  ResultState state = LoadingState();
  RestaurantListResponse? result;

  Future<void> fetchRestaurantList() async {
    try {
      state = LoadingState();
      notifyListeners();

      final data = await apiService.getRestaurantList();

      if (data.restaurants.isEmpty) {
        state = NoDataState('Data kosong');
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
