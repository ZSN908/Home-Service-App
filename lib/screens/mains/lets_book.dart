import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/tiles_cards_buttons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class LetsBookScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String image;

  const LetsBookScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  ConsumerState<LetsBookScreen> createState() => _LetsBookScreenState();
}

class _LetsBookScreenState extends ConsumerState<LetsBookScreen> {
  late ScrollController _scrollController;
  String _selectedSize = '';
  bool _isTitleBlack = false;
  DateTime _currentDate = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);
  int? _selectedDay;

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

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
      _selectedDay = null; // Reset selected day when changing the month
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
      _selectedDay = null; // Reset selected day when changing the month
    });
  }

  List<Map<String, String>> _getDaysInMonth() {
    // final firstDay = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0);

    return List.generate(
      lastDay.day,
      (index) {
        final dayDate =
            DateTime(_currentDate.year, _currentDate.month, index + 1);
        return {
          'day': (index + 1).toString(),
          'weekday': DateFormat('EEE').format(dayDate),
        };
      },
    );
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
                primary: Colors.black87, // Color.fromARGB(255, 214, 133, 11),
                secondary: Colors.black87,
                onSecondary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  Widget sizeButtion(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: _selectedSize == title
            ? Colors.black
            : const Color.fromARGB(255, 243, 243, 243),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedSize = _selectedSize == title ? '' : title;
        });
      },
      child: Text(
        title,
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
              color: _selectedSize == title ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget dateButtion(int day, String week, bool dark) {
    return SizedBox(
      width: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          backgroundColor:
              dark ? Colors.black : const Color.fromARGB(255, 243, 243, 243),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedDay = day;
          });
        },
        child: Text(
          '$day\n$week',
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              // fontWeight: FontWeight.w400,
              color: dark ? Colors.white : Colors.black,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth();
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
                errorWidget: (context, url, error) => GestureDetector(
                  onTap: () {
                    // Retry logic here
                  },
                  child: const Icon(Icons.refresh, color: Colors.red),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customTitleRow(
                    name: 'Apartment Size',
                    size: 17.7,
                    padd: false,
                    context: context,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.5, horizontal: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sizeButtion('1 BHK'),
                            sizeButtion('2 BHK'),
                            sizeButtion('2.5 BHK'),
                            sizeButtion('3 BHK'),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            sizeButtion('3.5 BHK'),
                            sizeButtion('4 BHK'),
                            sizeButtion('4.5 BHK'),
                            const SizedBox(width: 57),
                          ],
                        ),
                      ],
                    ),
                  ),
                  customTitleRow(
                    name: 'Area in Sqft',
                    size: 17.7,
                    padd: false,
                    context: context,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (double.tryParse(value) == null) {
                          // Show validation error or handle invalid input
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                        suffixIcon: const Icon(
                          Icons.add,
                          size: 22,
                        ),
                        hintText: 'Area in squre fit',
                        hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.59),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  customTitleRow(
                    name: 'Pick a date',
                    size: 17.9,
                    padd: false,
                    context: context,
                  ),
                  // Month and Year Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 25.7,
                        ),
                        onPressed: _goToPreviousMonth,
                      ),
                      Text(
                        DateFormat.yMMMM().format(_currentDate),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          size: 25.7,
                        ),
                        onPressed: _goToNextMonth,
                      ),
                    ],
                  ),
                  // Scrollable Dates
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0, bottom: 15),
                      child: Row(
                        children: daysInMonth.map((day) {
                          final isSelected =
                              _selectedDay == int.parse(day['day']!);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.5),
                            child: dateButtion(
                              int.parse(day['day']!),
                              day['weekday']!,
                              isSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  customTitleRow(
                    name: 'Pick a Time',
                    size: 17.9,
                    padd: false,
                    context: context,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Text(
                        'Selected time: ${_time.hour == 0 ? 12 : _time.hour}:${_time.minute} ${_time.hour >= 12 ? 'PM' : 'AM'}',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                    child: CustomButton(
                      title: 'SELECT TIME',
                      btnWidth: 1,
                      vertpadd: 0,
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 14.3),
                      onPressed: () => _selectTime(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                title: '\$ 1000',
                nextTitle: 'Continue',
                btnHeight: 43.0,
                btnWidth: 1,
                vertpadd: 0,
                textStyle: GoogleFonts.notoSansCarian(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.3,
                      fontWeight: FontWeight.w600),
                ),
                nextTextStyle: GoogleFonts.notoSansCarian(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.7,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
