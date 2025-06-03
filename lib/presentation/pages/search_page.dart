import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _query = query;
    });
    if (query.isNotEmpty) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).searchRestaurants(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search restaurants...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearch('');
              },
            ),
          ),
          onSubmitted: _onSearch,
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Enter a restaurant name to search'))
          : Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                if (provider.state == ResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.state == ResultState.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(provider.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _onSearch(_query),
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
                              builder: (context) => RestaurantDetailPage(
                                restaurantId: restaurant.id,
                              ),
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
