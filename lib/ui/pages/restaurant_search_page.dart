import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/api/api_service.dart';
import '../../provider/restaurant_search_provider.dart';
import '../../utils/result_state.dart';
import 'restaurant_detail_page.dart';

class RestaurantSearchPage extends StatelessWidget {
  const RestaurantSearchPage({super.key});

  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/small/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantSearchProvider(ApiService()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search Restaurant')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<RestaurantSearchProvider>(
                builder: (context, provider, _) {
                  return TextField(
                    decoration: const InputDecoration(
                      hintText: 'Cari restoran...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      provider.search(value);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer<RestaurantSearchProvider>(
                builder: (context, provider, _) {
                  final state = provider.state;

                  if (state is LoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ErrorState) {
                    return Center(child: Text(state.message));
                  }

                  if (state is NoDataState) {
                    return Center(child: Text(state.message));
                  }

                  if (state is HasDataState) {
                    final restaurants = state.data.restaurants;

                    return ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final r = restaurants[index];

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailPage(
                                  id: r.id,
                                  pictureId: r.pictureId,
                                ),
                              ),
                            );
                          },
                          leading: Hero(
                            tag: r.pictureId,
                            child: Image.network(
                              '$_imageBaseUrl${r.pictureId}',
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(r.name),
                          subtitle: Text('${r.city} • ⭐ ${r.rating}'),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
