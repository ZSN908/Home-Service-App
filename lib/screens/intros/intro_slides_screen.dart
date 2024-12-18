import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

class IntroSlidesScreen extends StatefulWidget {
  const IntroSlidesScreen({super.key});

  @override
  State<IntroSlidesScreen> createState() => _IntroSlidesScreenState();
}

class _IntroSlidesScreenState extends State<IntroSlidesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Give your home a makeover",
      "description":
          "The best services that you could find for your home, as we have everything that you are in need",
      "image": "hs_assets/images/h1.jpg",
    },
    {
      "title": "Qualified Professionals",
      "description":
          "Search From the list of Qualified Professionals around you as we bring the best one for you",
      "image": "hs_assets/images/h2.jpg",
    },
    {
      "title": "Easy & Fast Services",
      "description":
          "Book your services at your convenient time and enjoy the hassle free process",
      "image": "hs_assets/images/h3.jpg",
    },
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/LoginScr');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sliding background images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_slides[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // Static blurred container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(21.0),
                topRight: Radius.circular(21.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.385,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21.0),
                      topRight: Radius.circular(21.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: _buildIndicatorSection(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                          ),
                          child: Text(
                            _slides[_currentPage]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 27.5,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 37.0, vertical: 12.0),
                          child: Text(
                            _slides[_currentPage]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15.9,
                              // height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _currentPage == _slides.length - 1
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 9),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: _onNext,
                                        color: Colors.white,
                                        elevation: 0.7,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(37.0),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Text(
                                            "Get Started",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 12),
                                    child: IconButton(
                                      onPressed: _onNext,
                                      icon: const Icon(
                                        Icons.arrow_circle_right,
                                        size: 50,
                                        // shadows: [
                                        //   Shadow(
                                        //     color: Colors.black38,
                                        //     blurRadius: 5.0,
                                        //     offset: Offset(1, 2),
                                        //   ),
                                        // ],
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              _slides.length,
              (index) {
                // Calculate each indicator's width dynamically based on scroll offset
                double relativePosition = (pageOffset / screenWidth) - index;

                // Limit the relativePosition range to [-1, 1] for proper interpolation
                relativePosition = relativePosition.clamp(-1.0, 1.0);

                // Calculate width based on the relative position
                double indicatorWidth =
                    9.5 + (1 - relativePosition.abs()) * 9.0;

                return _buildIndicator(indicatorWidth);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(double width) {
    // Dynamically adjust the color based on the width
    Color? indicatorColor = ColorTween(
      begin: Colors.black38,
      end: Colors.white,
    ).transform(width / 20);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: width,
      height: 9.5,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(7.0),
      ),
    );
  }
}
