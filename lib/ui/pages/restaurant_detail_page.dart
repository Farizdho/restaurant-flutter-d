import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/api/api_service.dart';
import '../../provider/restaurant_detail_provider.dart';
import '../../provider/review_provider.dart';
import '../../utils/result_state.dart';

import '../../provider/favorite_provider.dart';
import '../../data/db/database_helper.dart';
import '../../data/model/favorite_restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;
  final String pictureId;

  const RestaurantDetailPage({
    super.key,
    required this.id,
    required this.pictureId,
  });

  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(ApiService(), widget.id),
        ),
        ChangeNotifierProvider(create: (_) => ReviewProvider(ApiService())),

        // ⭐ TAMBAHAN FAVORITE
        ChangeNotifierProvider(
          create: (_) =>
              FavoriteProvider(DatabaseHelper())..checkFavorite(widget.id),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Restaurant'),
          actions: [
            Consumer2<FavoriteProvider, RestaurantDetailProvider>(
              builder: (context, favProvider, detailProvider, _) {
                final state = detailProvider.state;

                if (state is! HasDataState) {
                  return const SizedBox();
                }

                final restaurant = state.data.restaurant;

                return IconButton(
                  icon: Icon(
                    favProvider.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    favProvider.toggleFavorite(
                      FavoriteRestaurant(
                        id: restaurant.id,
                        name: restaurant.name,
                        pictureId: restaurant.pictureId,
                        city: restaurant.city,
                        rating: restaurant.rating,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          favProvider.isFavorite
                              ? 'Dihapus dari favorit'
                              : 'Ditambahkan ke favorit',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, child) {
            final state = provider.state;

            // 🔄 LOADING
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            // ❌ ERROR
            if (state is ErrorState) {
              return Center(child: Text(state.message));
            }

            // 📭 NO DATA
            if (state is NoDataState) {
              return Center(child: Text(state.message));
            }

            // ✅ HAS DATA
            if (state is HasDataState) {
              final restaurant = state.data.restaurant;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🦸 HERO IMAGE
                    Hero(
                      tag: widget.pictureId,
                      child: Image.network(
                        '${RestaurantDetailPage._imageBaseUrl}${restaurant.pictureId}',
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏷️ NAME
                          Text(
                            restaurant.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),

                          const SizedBox(height: 8),

                          // 📍 LOCATION
                          Text('${restaurant.city} • ⭐ ${restaurant.rating}'),
                          Text(restaurant.address),

                          const SizedBox(height: 16),

                          // 📝 DESCRIPTION
                          Text(
                            restaurant.description,
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(height: 24),

                          // 🍽️ FOODS
                          const Text(
                            'Foods',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: restaurant.foods
                                .map<Widget>((food) => Chip(label: Text(food)))
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          // 🥤 DRINKS
                          const Text(
                            'Drinks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: restaurant.drinks
                                .map<Widget>(
                                  (drink) => Chip(label: Text(drink)),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          // ⭐ CUSTOMER REVIEWS
                          const Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...restaurant.customerReviews.map<Widget>(
                            (review) => ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(review.name),
                              subtitle: Text(review.review),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ✍️ ADD REVIEW
                          const Text(
                            'Add Review',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _reviewController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Review',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Consumer<ReviewProvider>(
                            builder: (context, reviewProvider, _) {
                              final reviewState = reviewProvider.state;

                              return ElevatedButton(
                                onPressed: reviewState is LoadingState
                                    ? null
                                    : () async {
                                        await reviewProvider.submitReview(
                                          id: restaurant.id,
                                          name: _nameController.text,
                                          review: _reviewController.text,
                                        );

                                        if (context.mounted &&
                                            reviewProvider.state
                                                is SuccessState) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Review berhasil dikirim',
                                              ),
                                            ),
                                          );

                                          _nameController.clear();
                                          _reviewController.clear();

                                          context
                                              .read<RestaurantDetailProvider>()
                                              .fetchDetail();
                                        }
                                      },
                                child: reviewState is LoadingState
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Submit Review'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
