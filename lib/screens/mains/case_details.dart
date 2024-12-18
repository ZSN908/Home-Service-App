import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:lottie/lottie.dart';

class CaseDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String detail;
  final String date;
  final String by;

  const CaseDetailsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.detail,
    required this.date,
    required this.by,
  });

  @override
  ConsumerState<CaseDetailsScreen> createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends ConsumerState<CaseDetailsScreen> {
  late ScrollController _scrollController;
  bool _isTitleBlack = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Change the title color based on the scroll position
    if (_scrollController.offset > 180 && !_isTitleBlack) {
      setState(() {
        _isTitleBlack = true;
      });
    } else if (_scrollController.offset <= 180 && _isTitleBlack) {
      setState(() {
        _isTitleBlack = false;
      });
    }
  }

  List<Widget> buildRatingStars(double rating,
      {double size = 21, Color color = Colors.yellow}) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return [
      for (int i = 0; i < fullStars; i++)
        Icon(Icons.star, size: size, color: color),
      if (hasHalfStar) Icon(Icons.star_half, size: size, color: color),
      for (int i = 0; i < emptyStars; i++)
        Icon(Icons.star_border, size: size, color: color),
    ];
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: _isTitleBlack ? Colors.black : Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.name,
                style: TextStyle(
                  color: _isTitleBlack ? Colors.black : Colors.transparent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.image,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://img.freepik.com/premium-photo/engineer-surveyor-builder-engineer-outdoors-surveying-work_67123-232.jpg',
                          // 'https://www.designingbuildings.co.uk/w/images/4/4a/Construction_Workers.jpg',
                          // 'https://insights.workwave.com/wp-content/uploads/2020/12/time-for-a-break-group-of-builders-in-working-uniform-are-eating-and-picture-id1142818948.jpg',
                          placeholder: (context, url) => Center(
                            child: Opacity(
                              opacity: 0.70,
                              child: Lottie.asset(
                                'hs_assets/animations/mirrorIndicator.json',
                                width: 37,
                                height: 37,
                                repeat: true,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 7),
                      SizedBox(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTitleRow(
                              name: 'Carl Smith',
                              size: 19,
                              padd: false,
                              context: context,
                              short: true,
                            ),
                            Row(
                              children: buildRatingStars(widget.rating,
                                  size: 21, color: Colors.yellow.shade600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 7),
                  customTitleRow(
                    name: 'Date And Time',
                    size: 18,
                    padd: false,
                    context: context,
                    short: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.date,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  customTitleRow(
                    name: 'Detail Review',
                    size: 18,
                    padd: false,
                    context: context,
                    short: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.detail,
                      style: const TextStyle(
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(23),
      //       topRight: Radius.circular(23),
      //     ),
      //   ),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: CustomButton(
      //           title: '\$ 1000',
      //           nextTitle: 'Continue',
      //           btnHeight: 43.0,
      //           btnWidth: 1,
      //           vertpadd: 0,
      //           textStyle: GoogleFonts.notoSansCarian(
      //             textStyle: const TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18.3,
      //                 fontWeight: FontWeight.w600),
      //           ),
      //           nextTextStyle: GoogleFonts.notoSansCarian(
      //             textStyle: const TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 15.7,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //           onPressed: () {},
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
