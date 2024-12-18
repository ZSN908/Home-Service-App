import 'package:flutter/material.dart';

class DealsSlider extends StatefulWidget {
  const DealsSlider({super.key});

  @override
  State<DealsSlider> createState() => _DealsSliderState();
}

class _DealsSliderState extends State<DealsSlider> {
  final PageController _pageController = PageController(
    viewportFraction: 0.93,
    initialPage: 1,
  );
  int _currentPage = 1;
  final List<Color> _colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.deepOrangeAccent,
  ];
  final List<String> images = [
    "hs_assets/images/slide1.jpg",
    "hs_assets/images/slide2.jpg",
    "hs_assets/images/slide3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slider
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _colors.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 300,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _colors[index],
                    image: DecorationImage(
                      image: AssetImage(images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Dynamic Indicators
        _buildIndicatorSection(),
      ],
    );
  }

  Widget _buildIndicatorSection() {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // Get the screen width
        final screenWidth = MediaQuery.of(context).size.width * 0.9;

        // Calculate the current scroll position
        final pageOffset = (_pageController.position.hasContentDimensions)
            ? _pageController.offset
            : _currentPage * screenWidth;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _colors.length,
              (index) {
                // Calculate each indicator's width dynamically based on scroll offset
                double relativePosition = (pageOffset / screenWidth) - index;

                // Limit the relativePosition range to [-1, 1] for proper interpolation
                relativePosition = relativePosition.clamp(-1.0, 1.0);

                // Calculate width based on the relative position
                double indicatorWidth =
                    7.5 + (1 - relativePosition.abs()) * 10.5;
                Color indicatorColor = _interpolateColor(relativePosition);

                return _buildIndicator(indicatorWidth, indicatorColor);
              },
            ),
          ),
        );
      },
    );
  }

  Color _interpolateColor(double relativePosition) {
    double t = (relativePosition.abs());
    return Color.lerp(Colors.black87, Colors.grey.shade500, t)!;
  }

  Widget _buildIndicator(double width, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: width,
      height: 7.5,
      decoration: BoxDecoration(
        color: color, // indicatorColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ReviewSlider extends StatefulWidget {
  const ReviewSlider({super.key});

  @override
  State<ReviewSlider> createState() => _ReviewSliderState();
}

class _ReviewSliderState extends State<ReviewSlider> {
  final PageController _pageController = PageController(
    viewportFraction: 1,
    initialPage: 1,
  );
  int _currentPage = 1;
  final List<Map<String, String>> _reviews = [
    {
      'name': 'John Smith',
      'rating': '3',
      'review':
          'Great experience! I use the app daily and it has become a vital part of my routine.',
    },
    {
      'name': 'Marry Jaine',
      'rating': '4',
      'review':
          'This is the best app for home services. It made my household tasks so much easier, and I really enjoy using it.',
    },
    {
      'name': 'Lian Caster',
      'rating': '5',
      'review':
          'Absolutely fantastic app! The user experience is seamless, and it offers everything I need for my home service tasks.',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.grey.shade300),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    _reviews[index]['name']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: _buildStarRating(
                                      int.parse(_reviews[index]['rating']!)),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _reviews[index]['review']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildIndicatorSection(),
      ],
    );
  }

  List<Widget> _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(Icons.star, size: 16, color: Colors.yellow));
      } else {
        stars
            .add(const Icon(Icons.star_border, size: 16, color: Colors.yellow));
      }
    }
    return stars;
  }

  Widget _buildIndicatorSection() {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // Get the screen width
        final screenWidth = MediaQuery.of(context).size.width;

        // Calculate the current scroll position
        final pageOffset = (_pageController.position.hasContentDimensions)
            ? _pageController.offset
            : _currentPage * screenWidth;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _reviews.length,
              (index) {
                // Calculate each indicator's width and color dynamically based on scroll offset
                double relativePosition = (pageOffset / screenWidth) - index;

                // Limit the relativePosition range to [-1, 1] for proper interpolation
                relativePosition = relativePosition.clamp(-1.0, 1.0);

                // Calculate width and interpolate color
                double indicatorWidth =
                    7.5 + (1 - relativePosition.abs()) * 2.3;
                Color indicatorColor = _interpolateColor(relativePosition);

                return _buildIndicator(indicatorWidth, indicatorColor);
              },
            ),
          ),
        );
      },
    );
  }

  Color _interpolateColor(double relativePosition) {
    // Interpolate between Colors.grey.shade700 and Colors.grey.shade300
    double t = (relativePosition.abs());
    return Color.lerp(Colors.grey.shade700, Colors.grey.shade300, t)!;
  }

  Widget _buildIndicator(double width, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: width,
      height: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
