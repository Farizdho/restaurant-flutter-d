import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:restaurant_dicoding/provider/restaurant_list_provider.dart';
import 'package:restaurant_dicoding/data/api/api_service.dart';
import 'package:restaurant_dicoding/utils/result_state.dart';
import 'package:restaurant_dicoding/data/model/restaurant_list_response.dart';

// ================= MOCK =================
class MockApiService extends Mock implements ApiService {}

void main() {
  late RestaurantListProvider provider;
  late MockApiService apiService;

  setUp(() {
    apiService = MockApiService();
  });

  // ✅ TEST 1 — initial state
  test('initial state should be LoadingState', () {
    provider = RestaurantListProvider(apiService);
    expect(provider.state, isA<LoadingState>());
  });

  // ✅ TEST 2 — success fetch
  test('should return HasDataState when API success', () async {
    final fakeResponse = RestaurantListResponse(
      error: false,
      message: 'success',
      count: 1,
      restaurants: [],
    );

    when(apiService.getRestaurantList()).thenAnswer((_) async => fakeResponse);

    provider = RestaurantListProvider(apiService);
    await provider.fetchRestaurantList();

    expect(provider.state, isA<HasDataState>());
  });

  // ✅ TEST 3 — error fetch
  test('should return ErrorState when API fails', () async {
    when(apiService.getRestaurantList()).thenThrow(Exception('Failed'));

    provider = RestaurantListProvider(apiService);
    await provider.fetchRestaurantList();

    expect(provider.state, isA<ErrorState>());
  });
}
