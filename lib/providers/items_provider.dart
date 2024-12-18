import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==================<( ServicePeople Provider )>==================
final servicePeopleProvider =
    StateNotifierProvider<ServicePeopleNotifier, List<ServicePerson>>(
  (ref) => ServicePeopleNotifier(),
);

class ServicePeopleNotifier extends StateNotifier<List<ServicePerson>> {
  ServicePeopleNotifier() : super([]);

  final _firestore = FirebaseFirestore.instance;

  // Local collection variable
  List<ServicePerson> _localServicePeopleCollection = [];

  // Fetch and set collection to local variable
  Future<void> fetchAndSetServicePeopleCollection() async {
    try {
      final snapshot = await _firestore.collection('ServiceProviders').get();
      _localServicePeopleCollection = snapshot.docs
          .map((doc) => ServicePerson.fromMap(doc.data(), doc.id))
          .toList();

      // // Save full collection to SharedPreferences
      // await _saveCollectionToSharedPreferences(_localServicePeopleCollection);

      // Update state
      state = _localServicePeopleCollection;
      log('ServiceProviders collection fetched and saved');
    } catch (e) {
      log('Error fetching ServiceProviders collection: $e');
    }
  }

  // Real-time listener for changes in the ServiceProviders collection
  void listenForServicePeopleCollectionChanges() {
    _firestore.collection('ServiceProviders').snapshots().listen((snapshot) {
      final updatedCollection = snapshot.docs
          .map((doc) => ServicePerson.fromMap(doc.data(), doc.id))
          .toList();

      // Update local collection and state
      _localServicePeopleCollection = updatedCollection;
      state = updatedCollection;

      // // Save updated collection to SharedPreferences
      // _saveCollectionToSharedPreferences(updatedCollection);

      log('Real-time update received for ServiceProviders collection');
    });
  }

  // // Save full collection data to SharedPreferences as JSON
  // Future<void> _saveCollectionToSharedPreferences(
  //     List<ServiceProvider> collection) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String> jsonData = collection
  //       .map((serviceProvider) => jsonEncode(serviceProvider.toMap()))
  //       .toList();
  //   await prefs.setStringList('servicePeopleCollection', jsonData);
  //   log('ServiceProviders collection saved to SharedPreferences');
  // }

  // // Retrieve collection from SharedPreferences
  // Future<void> loadCollectionFromSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String>? jsonData =
  //       prefs.getStringList('servicePeopleCollection');

  //   if (jsonData != null) {
  //     _localServicePeopleCollection = jsonData
  //         .map((jsonItem) => ServiceProvider.fromMap(jsonDecode(jsonItem), ''))
  //         .toList();
  //     state = _localServicePeopleCollection;
  //     log('ServiceProviders collection loaded from SharedPreferences');
  //   }
  // }
}

// // Add this method in ServiceProvider class to convert the object to a Map
// extension on ServiceProvider {
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'about': about,
//       'image': image,
//       'rating': rating,
//       'jobs': jobs,
//       'price': price,
//       'service': service,
//       'createdAt': createdAt,
//     };
//   }
// }

// =================<( Showcase Provider )>=================
final showcaseProvider =
    StateNotifierProvider<ShowcaseNotifier, List<Showcase>>(
  (ref) => ShowcaseNotifier(),
);

class ShowcaseNotifier extends StateNotifier<List<Showcase>> {
  ShowcaseNotifier() : super([]);

  final _firestore = FirebaseFirestore.instance;

  List<Showcase> _localShowcaseCollection = [];

  Future<void> fetchAndSetShowcaseCollection() async {
    try {
      final snapshot = await _firestore.collection('Showcase').get();
      _localShowcaseCollection = snapshot.docs
          .map((doc) => Showcase.fromMap(doc.data(), doc.id))
          .toList();

      // await _saveCollectionToSharedPreferences(_localShowcaseCollection);

      state = _localShowcaseCollection;
      log('Showcase collection fetched and saved');
    } catch (e) {
      log('Error fetching Showcase collection: $e');
    }
  }

  void listenForShowcaseCollectionChanges() {
    _firestore.collection('Showcase').snapshots().listen((snapshot) {
      final updatedCollection = snapshot.docs
          .map((doc) => Showcase.fromMap(doc.data(), doc.id))
          .toList();

      _localShowcaseCollection = updatedCollection;
      state = updatedCollection;

      // _saveCollectionToSharedPreferences(updatedCollection);

      log('Real-time update received for Showcase collection');
    });
  }

  // Future<void> _saveCollectionToSharedPreferences(
  //     List<Showcase> collection) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String> jsonData =
  //       collection.map((showcase) => jsonEncode(showcase.toMap())).toList();
  //   await prefs.setStringList('showcaseCollection', jsonData);
  //   log('Showcase collection saved to SharedPreferences');
  // }

  // Future<void> loadCollectionFromSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String>? jsonData = prefs.getStringList('showcaseCollection');

  //   if (jsonData != null) {
  //     _localShowcaseCollection = jsonData
  //         .map((jsonItem) => Showcase.fromMap(jsonDecode(jsonItem), ''))
  //         .toList();
  //     state = _localShowcaseCollection;
  //     log('Showcase collection loaded from SharedPreferences');
  //   }
  // }
}

// ==================<( Packages Provider )>=================
final packagesProvider = StateNotifierProvider<PackagesNotifier, List<Package>>(
  (ref) => PackagesNotifier(),
);

class PackagesNotifier extends StateNotifier<List<Package>> {
  PackagesNotifier() : super([]);

  final _firestore = FirebaseFirestore.instance;

  List<Package> _localPackagesCollection = [];

  Future<void> fetchAndSetPackagesCollection() async {
    try {
      final snapshot = await _firestore.collection('Packages').get();
      _localPackagesCollection = snapshot.docs
          .map((doc) => Package.fromMap(doc.data(), doc.id))
          .toList();

      // await _saveCollectionToSharedPreferences(_localPackagesCollection);

      state = _localPackagesCollection;
      log('Packages collection fetched and saved');
    } catch (e) {
      log('Error fetching Packages collection: $e');
    }
  }

  void listenForPackagesCollectionChanges() {
    _firestore.collection('Packages').snapshots().listen((snapshot) {
      final updatedCollection = snapshot.docs
          .map((doc) => Package.fromMap(doc.data(), doc.id))
          .toList();

      _localPackagesCollection = updatedCollection;
      state = updatedCollection;

      // _saveCollectionToSharedPreferences(updatedCollection);

      log('Real-time update received for Packages collection');
    });
  }

  // Future<void> _saveCollectionToSharedPreferences(
  //     List<Package> collection) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String> jsonData =
  //       collection.map((package) => jsonEncode(package.toMap())).toList();
  //   await prefs.setStringList('packagesCollection', jsonData);
  //   log('Packages collection saved to SharedPreferences');
  // }

  // Future<void> loadCollectionFromSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final List<String>? jsonData = prefs.getStringList('packagesCollection');

  //   if (jsonData != null) {
  //     _localPackagesCollection = jsonData
  //         .map((jsonItem) => Package.fromMap(jsonDecode(jsonItem), ''))
  //         .toList();
  //     state = _localPackagesCollection;
  //     log('Packages collection loaded from SharedPreferences');
  //   }
  // }
}

//          +++++++++<<<({ Models })>>>+++++++
//---------------[ ServiceProvider Model ]--------------
class ServicePerson {
  final String id;
  final String name;
  final String about;
  final String image;
  final double rating;
  final int jobs;
  final String price;
  final String service;
  final Timestamp createdAt;

  ServicePerson({
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.rating,
    required this.jobs,
    required this.price,
    required this.service,
    required this.createdAt,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'about': about,
  //     'image': image,
  //     'rating': rating,
  //     'jobs': jobs,
  //     'price': price,
  //     'service': service,
  //     'createdAt': createdAt.toDate().toIso8601String(),
  //   };
  // }

  factory ServicePerson.fromMap(Map<String, dynamic> data, String id) {
    return ServicePerson(
      id: id,
      name: data['name'] ?? 'Unknown',
      about: data['about'] ?? 'No description available',
      image: data['image'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      jobs: data['jobs'] ?? 0,
      price: data['price'] ?? '',
      service: data['service'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt']
          : Timestamp.fromDate(DateTime.parse(data['createdAt'])),
    );
  }
}

//------------------[ Showcase Model ]-----------------
class Showcase {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String detail;
  final String date;
  final String by;
  final Timestamp createdAt;

  Showcase({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.detail,
    required this.date,
    required this.by,
    required this.createdAt,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'image': image,
  //     'rating': rating,
  //     'detail': detail,
  //     'date': date,
  //     'by': by,
  //     'createdAt': createdAt.toDate().toIso8601String(),
  //   };
  // }

  factory Showcase.fromMap(Map<String, dynamic> data, String id) {
    return Showcase(
      id: id,
      name: data['name'] ?? 'Unknown',
      image: data['image'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      detail: data['detail'] ?? 'No details available',
      date: data['date'] ?? '',
      by: data['by'] ?? 'Anonymous',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt']
          : Timestamp.fromDate(DateTime.parse(data['createdAt'])),
    );
  }
}

//-------------------[ Package Model ]-----------------
class Package {
  final String id;
  final String name;
  final String image;
  final String price;
  final String detail;
  final String type;
  final Timestamp createdAt;

  Package({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.detail,
    required this.type,
    required this.createdAt,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'image': image,
  //     'price': price,
  //     'detail': detail,
  //     'type': type,
  //     'createdAt': createdAt.toDate().toIso8601String(),
  //   };
  // }

  factory Package.fromMap(Map<String, dynamic> data, String id) {
    return Package(
      id: id,
      name: data['name'] ?? 'Unknown',
      image: data['image'] ?? '',
      price: data['price'] ?? '0 Rs',
      detail: data['detail'] ?? 'No details available',
      type: data['type'] ?? 'Unknown',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt']
          : Timestamp.fromDate(DateTime.parse(data['createdAt'])),
    );
  }
}
