import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_service/providers/items_provider.dart';
import 'package:home_service/screens/components/services_and_constructions.dart';
import 'package:home_service/screens/mains/view_all.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:home_service/widgets/sliders.dart';
import 'package:home_service/screens/components/drawer_menu.dart';
import 'package:home_service/widgets/item_lists.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetching all packages from the provider
    final allPackages = ref.watch(packagesProvider);

    // // Filtering the packages into 'single' and 'combo' types
    // final singlePackages =
    //     allPackages.where((item) => item.type == 'single').toList();
    final comboPackages =
        allPackages.where((item) => item.type == 'combo').toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        // title: const Text("Home"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              iconSize: 29,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to Notification Screen
              Navigator.pushNamed(context, '/NotificationScr');
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Search');
                },
                child: Container(
                  height: 47, // Adjust height
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Search for services',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.57),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.search,
                        size: 22,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              height: 197,
              margin: const EdgeInsets.only(top: 5, bottom: 1),
              padding: const EdgeInsets.only(top: 15),
              width: double.infinity,
              child: const DealsSlider(),
            ),

            const ServicesAndConstructions(),

            const SizedBox(height: 19),

            customTitleRow(
              name: 'Popular Services',
              btn: true,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewAllScreen(
                      title: 'Service Providers',
                    ),
                  ),
                );
              },
              context: context,
            ),
            CustomLists(
              horizontalList: true,
              styleNum: '1',
              itemsCollection: ref.watch(servicePeopleProvider),
              showcase: false,
            ),

            customTitleRow(
              name: 'Renovate your home',
              btn: true,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewAllScreen(
                      title: 'Renovate your home',
                      isProviderList: false,
                    ),
                  ),
                );
              },
              context: context,
            ),
            CustomLists(
              horizontalList: true,
              styleNum: '2',
              itemsCollection: ref.watch(showcaseProvider),
              showcase: false,
            ),

            customTitleRow(
              name: 'Combos And Subscriptions',
              btn: true,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewAllScreen(
                      title: 'Renovate your home',
                      isProviderList: false,
                      isPackage: true,
                    ),
                  ),
                );
              },
              context: context,
            ),
            CustomLists(
              horizontalList: true,
              styleNum: '3',
              itemsCollection: comboPackages,
              showcase: false,
            ),

            customTitleRow(
              name: 'What our customers say',
              context: context,
            ),
            Container(
              height: 142,
              margin: const EdgeInsets.only(top: 3, bottom: 1),
              padding: const EdgeInsets.only(top: 0),
              width: double.infinity,
              child: const ReviewSlider(),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
