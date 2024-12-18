import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/items_provider.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:home_service/widgets/item_lists.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

// class FavoritesScreen extends ConsumerWidget {
//   const FavoritesScreen({super.key});
class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    // Read the user data from the provider
    final userData = ref.watch(userProvider);
    final favorites = userData?.favorites ?? [];

    // Fetching all packages from the provider
    final favoritesItemsCollection = ref.watch(servicePeopleProvider);

    // Filter the items based on the user's favorites list
    final filteredFavorites = favoritesItemsCollection
        .where((item) => favorites.contains(item.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Service Providers",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: favorites.isEmpty
          ? customEmptyCollection(
              context: context,
              title: "\n\nNo Favorite Item!",
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: filteredFavorites.isNotEmpty
                    ? (filteredFavorites.length + 2)
                    : 0,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 0, height: 16),
                itemBuilder: (context, index) {
                  if (index == 0 || index == filteredFavorites.length + 1) {
                    return const SizedBox(height: 0);
                  }

                  // Ensure the list is not empty and adjust the index
                  if (filteredFavorites.isEmpty) {
                    return const Center(
                      child: Text('No items available'),
                    );
                  }

                  // Render dynamic data
                  final item = filteredFavorites[index - 1];
                  // final title = item.name;
                  // final imageUrl = item.image;

                  return FavCard(
                    id: item.id,
                    name: item.name,
                    about: item.about,
                    image: item.image,
                    rating: item.rating,
                    jobs: item.jobs,
                    price: item.price,
                    service: item.service,
                    isFavorite: true,
                    toggleFavorite: () {
                      ref.read(userProvider.notifier).toggleFavorite(item.id);
                    },
                  );
                },
              ),
            ),
    );
  }
}
