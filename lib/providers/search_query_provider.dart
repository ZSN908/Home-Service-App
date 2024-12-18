import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/items_provider.dart';

// Provider for search query state
final searchQueryProvider = StateProvider<String>((_) => '');

// Provider for filtered and sorted service providers
final filteredServicePeopleProvider = Provider<List<ServicePerson>>((ref) {
  final servicePeople = ref.watch(servicePeopleProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  // Filter by name, service, or price and sort by rating
  return servicePeople
      .where((item) =>
          item.name.toLowerCase().contains(searchQuery) ||
          item.service.toLowerCase().contains(searchQuery) ||
          item.price.toLowerCase().contains(searchQuery))
      .toList()
    ..sort((a, b) => b.rating.compareTo(a.rating));
});
