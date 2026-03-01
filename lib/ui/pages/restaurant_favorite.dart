import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/favorite_provider.dart';
import '../../data/db/database_helper.dart';
import 'restaurant_detail_page.dart';

class RestaurantFavorite extends StatelessWidget {
  const RestaurantFavorite({super.key});

  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/small/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteProvider(DatabaseHelper()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Favorite Restaurant')),
        body: Consumer<FavoriteProvider>(
          builder: (context, provider, _) {
            final favorites = provider.favorites;

            if (favorites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80),
                    SizedBox(height: 16),
                    Text('Belum ada restoran favorit'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      '$_imageBaseUrl${restaurant.pictureId}',
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(restaurant.name),
                    subtitle: Text(
                      '${restaurant.city} • ⭐ ${restaurant.rating}',
                    ),

                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailPage(
                            id: restaurant.id,
                            pictureId: restaurant.pictureId,
                          ),
                        ),
                      );
                      if (context.mounted) {
                        provider.loadFavorites();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
