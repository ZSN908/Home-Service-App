import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_service/providers/search_query_provider.dart';
import 'package:home_service/widgets/item_lists.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  // String _searchQuery = '';

  Timer? _debounce;

  // Handle search input with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // // Watch the full collection of service providers
    // final servicePeople = ref.watch(servicePeopleProvider);

    // // Apply filtering and sorting based on the search query
    // final filteredList = servicePeople
    //     .where((item) =>
    //         item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
    //         item.service.toLowerCase().contains(_searchQuery.toLowerCase()) ||
    //         item.price.toLowerCase().contains(_searchQuery.toLowerCase()))
    //     .toList()
    //   ..sort((a, b) => b.rating.compareTo(a.rating));

    // Watch the filtered list of service people
    final filteredList = ref.watch(filteredServicePeopleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                suffixIcon: const Icon(
                  Icons.search,
                  size: 22,
                ),
                hintText: 'Search for services',
                hintStyle: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.57),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _onSearchChanged,
              //  (value) {
              //   setState(() {
              //     _searchQuery = value;
              //   });
              // },
            ),
          ),
          Expanded(
            child: CustomLists(
              horizontalList: false,
              styleNum: 'none',
              itemsCollection: filteredList, //ref.watch(servicePeopleProvider),
              showcase: false,
            ),
          ),
        ],
      ),
    );
  }
}
