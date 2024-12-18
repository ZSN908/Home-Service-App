import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/items_provider.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:home_service/screens/mains/case_details.dart';
import 'package:home_service/screens/mains/lets_book.dart';
import 'package:home_service/widgets/item_lists.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:lottie/lottie.dart';

class ViewAllScreen extends ConsumerWidget {
  final String title;
  final bool isProviderList;
  final bool isPackage;
  final bool isCase;
  const ViewAllScreen({
    super.key,
    required this.title,
    this.isProviderList = true,
    this.isPackage = false,
    this.isCase = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);
    final favorites = userData?.favorites ?? [];

    final itemCollection =
        isProviderList ? ref.watch(servicePeopleProvider) : [];
    final showcaseCollection = isProviderList
        ? []
        : isPackage
            ? []
            : ref.watch(showcaseProvider);
    final packageCollection = isProviderList
        ? []
        : isPackage
            ? ref.watch(packagesProvider)
            : [];

    final filteredCollection =
        (title == 'Service Providers' || title == 'Home Services')
            ? itemCollection
            : itemCollection
                .where((provider) => provider.service == title)
                .toList();

    final isCollectionEmpty = isProviderList
        ? filteredCollection.isEmpty
        : isPackage
            ? packageCollection.isEmpty
            : showcaseCollection.isEmpty;

    Widget buildList(List collection, Widget Function(dynamic) itemBuilder) {
      return ListView.separated(
        itemCount: collection.length + 2,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0 || index == collection.length + 1) {
            return const SizedBox(height: 0);
          }
          return itemBuilder(collection[index - 1]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      body: isCollectionEmpty
          ? customEmptyCollection(
              context: context,
              title: "\n\nNo $title Item!",
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: buildList(
                isProviderList
                    ? filteredCollection
                    : isPackage
                        ? packageCollection
                        : showcaseCollection,
                (item) => isProviderList
                    ? FavCard(
                        id: item.id,
                        name: item.name,
                        about: item.about,
                        image: item.image,
                        rating: item.rating,
                        jobs: item.jobs,
                        price: item.price,
                        service: item.service,
                        isFavorite: favorites.contains(item.id),
                        toggleFavorite: () => ref
                            .read(userProvider.notifier)
                            .toggleFavorite(item.id),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => !isCase
                                ? LetsBookScreen(
                                    id: item.id,
                                    name: item.name,
                                    image: item.image,
                                  )
                                : CaseDetailsScreen(
                                    id: item.id,
                                    name: item.name,
                                    image: item.image,
                                    rating: item.rating,
                                    detail: item.detail,
                                    date: item.date,
                                    by: item.by,
                                  ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 89,
                              width: 89,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: item.image,
                                placeholder: (_, __) => Center(
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Lottie.asset(
                                      'hs_assets/animations/mirrorIndicator.json',
                                      width: 30,
                                      height: 30,
                                      repeat: true,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
    );
  }
}
