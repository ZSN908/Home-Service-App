import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/items_provider.dart';
import 'package:home_service/screens/mains/account_screen.dart';
import 'package:home_service/screens/mains/booking_screen.dart';
import 'package:home_service/screens/mains/home_screen.dart';
import 'package:home_service/screens/mains/search_screen.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const BookingScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ref
        .read(servicePeopleProvider.notifier)
        .listenForServicePeopleCollectionChanges();
    ref.read(showcaseProvider.notifier).listenForShowcaseCollectionChanges();
    ref.read(packagesProvider.notifier).listenForPackagesCollectionChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 30,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        // unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.black87),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 21,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: _selectedIndex == 0 ? Colors.black : Colors.grey,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.account_balance_wallet
                    : Icons.account_balance_wallet_outlined,
                color: _selectedIndex == 1 ? Colors.black : Colors.grey,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? Icons.calendar_month
                    : Icons.calendar_month_outlined,
                color: _selectedIndex == 2 ? Colors.black : Colors.grey,
              ),
              label: 'Booking'),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline_rounded,
              color: _selectedIndex == 3 ? Colors.black : Colors.grey,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:home_service/screens/main/account_screen.dart';
// import 'package:home_service/screens/main/booking_screen.dart';
// import 'package:home_service/screens/main/home_screen.dart';
// import 'package:home_service/screens/main/search_screen.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     SearchScreen(),
//     BookingScreen(),
//     AccountScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.account_circle), label: 'Account'),
//         ],
//       ),
//     );
//   }
// }
