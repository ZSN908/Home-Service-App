import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_service/screens/mains/case_details.dart';
import 'package:home_service/screens/mains/details.dart';
import 'package:home_service/screens/mains/lets_book.dart';
import 'package:lottie/lottie.dart';

class CustomLists extends ConsumerWidget {
  final bool horizontalList;
  final List<dynamic> itemsCollection;
  final String styleNum;
  final bool showcase;

  const CustomLists({
    super.key,
    required this.horizontalList,
    required this.itemsCollection,
    required this.styleNum,
    required this.showcase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: styleNum == '1' ? 140 : 155,
      child: ListView.separated(
        scrollDirection: horizontalList ? Axis.horizontal : Axis.vertical,
        itemCount:
            itemsCollection.isNotEmpty ? (itemsCollection.length + 2) : 0,
        separatorBuilder: (context, index) => SizedBox(
          width: horizontalList ? 17 : 0,
          height: horizontalList ? 0 : 16,
        ),
        itemBuilder: (context, index) {
          if (index == 0 || index == itemsCollection.length + 1) {
            return const SizedBox(width: 0, height: 0);
          }

          // Ensure the list is not empty and adjust the index
          if (itemsCollection.isEmpty) {
            return const Center(
              child: Text('No items available'),
            );
          }

          // Render dynamic data
          final item = itemsCollection[index - 1];
          final title = item.name;
          final imageUrl = item.image;

          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: horizontalList ? 0.0 : 16.0),
            child: GestureDetector(
              onTap: () {
                if (styleNum == '1' || styleNum == 'none') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailsScreen(
                        id: item.id,
                        name: item.name,
                        image: item.image,
                        about: item.about,
                        jobs: item.jobs,
                        rating: item.rating,
                      ),
                    ),
                  );
                } else if (showcase) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CaseDetailsScreen(
                        id: item.id,
                        name: item.name,
                        image: item.image,
                        rating: item.rating,
                        detail: item.detail,
                        date: item.date,
                        by: item.by,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LetsBookScreen(
                        id: item.id,
                        name: item.name,
                        image: item.image,
                      ),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height:
                            horizontalList ? (styleNum == '1' ? 115 : 97) : 90,
                        width: horizontalList
                            ? (styleNum == '1'
                                ? 105
                                : styleNum == '2'
                                    ? 160
                                    : 170)
                            : 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              BorderRadius.circular(horizontalList ? 17 : 15),
                        ),
                        // alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) => Center(
                                  child: Opacity(
                                    opacity: 0.70,
                                    child: Lottie.asset(
                                      'hs_assets/animations/mirrorIndicator.json',
                                      width: 43,
                                      height: 43,
                                      repeat: true,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                      ),
                      if (!horizontalList) ...[
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              // 'Plumbers',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.8,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                item.about,
                                // 'Who helps you in plumbing work',
                                style: const TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  if (styleNum != '1' && horizontalList)
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: SizedBox(
                        width: horizontalList
                            ? (styleNum == '1'
                                ? 105
                                : styleNum == '2'
                                    ? 160
                                    : 170)
                            : 90,
                        child: Text(
                          title ?? 'no title',
                          style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget customEmptyCollection({
  required BuildContext context,
  required String title,
}) {
  return Stack(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 147.0),
              child: Opacity(
                opacity: 0.70,
                child: Lottie.asset(
                  'hs_assets/animations/silverList.json',
                  width: 330,
                  height: 330,
                  repeat: true,
                ),
              ),
            ),
          ),
        ],
      ),
      Center(
        child: Text(
          title,
          style: GoogleFonts.openSans(
            textStyle: const TextStyle(
              fontSize: 16.7,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 236, 234, 236),
            ),
          ),
        ),
      ),
    ],
  );
}

// class VerticalList extends StatelessWidget {
//   // final String styleNum;
//   const VerticalList({
//     super.key,
//     // required this.styleNum,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 155,
//       child: ListView.separated(
//         scrollDirection: Axis.vertical,
//         itemCount: 10,
//         separatorBuilder: (context, index) => const SizedBox(height: 17),
//         itemBuilder: (context, index) {
//           if (index == 0 || index == 9) {
//             return const SizedBox(height: 0);
//           }
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 Container(
//                   height: 90,
//                   width: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   alignment: Alignment.center,
//                 ),
//                 const SizedBox(width: 14),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Plumbers',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         height: 1.8,
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.6,
//                       child: const Text(
//                         'Who helps you in plumbing work',
//                         style: TextStyle(fontSize: 15),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
