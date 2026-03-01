import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';
import 'package:restaurant_dicoding/provider/restaurant_list_provider.dart';
import 'package:restaurant_dicoding/data/model/restaurant_list_response.dart';
import 'package:restaurant_dicoding/utils/result_state.dart';

import 'package:restaurant_dicoding/data/model/restaurant.dart';

void main() {
  late MockApiService mockApiService;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantListProvider(apiService: mockApiService);
  });

  test('initial state should be LoadingState', () {
    expect(provider.state, isA<LoadingState>());
  });

  test('should return HasDataState when API success', () async {
    final fakeResponse = RestaurantListResponse(
      error: false,
      message: 'success',
      count: 1,
      restaurants: [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Test',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2,
        ),
      ],
    );

    when(
      mockApiService.getRestaurantList(),
    ).thenAnswer((_) async => fakeResponse);

    await provider.fetchRestaurantList();

    expect(provider.state, isA<HasDataState>());
  });

  test('should return ErrorState when API fails', () async {
    when(mockApiService.getRestaurantList()).thenThrow(Exception('Failed'));

    await provider.fetchRestaurantList();

    expect(provider.state, isA<ErrorState>());
  });
}
