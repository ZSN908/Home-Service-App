import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for a string
final serviceStateProvider = StateProvider<String>((ref) {
  return 'Plumber';
});

// // -------===<{ Global loading provider }>===------
// final globalLoadingProvider =
//     StateNotifierProvider<GlobalLoadingNotifier, bool>(
//   (ref) => GlobalLoadingNotifier(),
// );

// class GlobalLoadingNotifier extends StateNotifier<bool> {
//   GlobalLoadingNotifier() : super(false);

//   // Set loading to true
//   void startLoading() {
//     state = true;
//   }

//   // Set loading to false
//   void stopLoading() {
//     state = false;
//   }
// }
