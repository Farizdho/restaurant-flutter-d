import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../utils/result_state.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider(this.apiService);

  ResultState _state = IdleState();
  ResultState get state => _state;

  Future<void> submitReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      _state = LoadingState();
      notifyListeners();

      await apiService.addReview(id: id, name: name, review: review);

      _state = SuccessState('Review berhasil dikirim');
      notifyListeners();
    } catch (e) {
      _state = ErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _state = IdleState();
    notifyListeners();
  }
}
