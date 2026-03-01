import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/restaurant_list_provider.dart';
import '../../utils/result_state.dart';

import 'restaurant_detail_page.dart';
import 'restaurant_search_page.dart';

import 'restaurant_favorite.dart';

import 'restaurant_setting.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/small/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RestaurantSearchPage()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RestaurantFavorite()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RestaurantSettings()),
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ErrorState) {
            return Center(
              child: Text(state.message, textAlign: TextAlign.center),
            );
          }

          if (state is NoDataState) {
            return Center(child: Text(state.message));
          }

          if (state is HasDataState) {
            final restaurants = state.data.restaurants;

            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailPage(
                          id: restaurant.id,
                          pictureId: restaurant.pictureId,
                        ),
                      ),
                    );
                  },
                  leading: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                      '$_imageBaseUrl${restaurant.pictureId}',
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text('${restaurant.city} • ⭐ ${restaurant.rating}'),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
