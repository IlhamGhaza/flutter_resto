import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/restaurant_provider.dart';
import 'restaurant_detail_page.dart';
import 'search_page.dart';
import '../widgets/restaurant_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchRestaurants(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (provider.state == ResultState.noData) {
            return const Center(child: Text('No restaurants found'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = provider.restaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RestaurantDetailPage(restaurantId: restaurant.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
