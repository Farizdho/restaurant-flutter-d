import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../utils/result_state.dart';
import '../data/model/restaurant_detail_response.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailProvider(this.apiService, this.id) {
    fetchDetail();
  }

  ResultState state = LoadingState();
  RestaurantDetailResponse? result;

  Future<void> fetchDetail() async {
    try {
      state = LoadingState();
      notifyListeners();

      final data = await apiService.getRestaurantDetail(id);

      if (data.restaurant.id.isEmpty) {
        state = NoDataState('Data tidak ditemukan');
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
