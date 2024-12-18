import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/items_provider.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:home_service/screens/mains/view_all.dart';
import 'package:home_service/widgets/item_lists.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:lottie/lottie.dart';

// class DetailsScreen extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
// }
// class _DetailsScreenState extends ConsumerState<DetailsScreen> {

class DetailsScreen extends ConsumerWidget {
  final String id;
  final String name;
  final String image;
  final String about;
  final int jobs;
  final double rating;
  const DetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.about,
    required this.jobs,
    required this.rating,
  });

  Widget verticalTile({required String title, required Widget related}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        related,
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the user data from the provider
    final userData = ref.watch(userProvider);
    final favoriteList = userData?.favorites ?? [];
    // Check if the item is in the favorites list
    final bool isFavorite = favoriteList.contains(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customTitleRow(
                  name: name,
                  context: context,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    about,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 6,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 19.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 215,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (context, url) => Center(
                            child: Opacity(
                              opacity: 0.70,
                              child: Lottie.asset(
                                'hs_assets/animations/mirrorIndicator.json',
                                width: 47,
                                height: 47,
                                repeat: true,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 215,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 65,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.07),
                                    Colors.black,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  verticalTile(
                                    title: 'Jobs',
                                    related: Text(
                                      jobs.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  verticalTile(
                                    title: 'Share',
                                    related: InkWell(
                                      onTap: () {},
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                  verticalTile(
                                    title: 'Rating',
                                    related: Text(
                                      rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  verticalTile(
                                    title: 'Save',
                                    related: InkWell(
                                      onTap: () {
                                        ref
                                            .read(userProvider.notifier)
                                            .toggleFavorite(id);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 29),
                customTitleRow(
                  name: 'Recent Projects',
                  btn: true,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewAllScreen(
                          title: 'Recent Projects',
                          isProviderList: false,
                          isCase: true,
                        ),
                      ),
                    );
                  },
                  context: context,
                ),
                CustomLists(
                  horizontalList: true,
                  styleNum: '3',
                  itemsCollection: ref.watch(showcaseProvider),
                  showcase: true,
                ),
                const SizedBox(height: 75),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        icon: Icons.message,
                        btnHeight: 43.0,
                        btnWidth: 1,
                        color: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 14.3),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomButton(
                        title: 'Book',
                        btnHeight: 43.0,
                        btnWidth: 1,
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: 14.3),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
