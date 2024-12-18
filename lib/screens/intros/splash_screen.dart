import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void _goToScr(String scrIndex) {
    Navigator.pushReplacementNamed(context, scrIndex);
  }

  // Future<void> fetchInitialCollections(WidgetRef ref) async {
  //   await ref
  //       .read(servicePeopleProvider.notifier)
  //       .fetchAndSetServicePeopleCollection();
  //   await ref.read(showcaseProvider.notifier).fetchAndSetShowcaseCollection();
  //   await ref.read(packagesProvider.notifier).fetchAndSetPackagesCollection();
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      log('Wellcome to Splash!');
      if (FirebaseAuth.instance.currentUser != null) {
        // Fetch and update user data after successful otp validation
        await ref.read(userProvider.notifier).initialize();

        // // Load from SharedPreferences first for faster display
        // await ref
        //     .read(servicePeopleProvider.notifier)
        //     .loadCollectionFromSharedPreferences();
        // await ref
        //     .read(showcaseProvider.notifier)
        //     .loadCollectionFromSharedPreferences();
        // await ref
        //     .read(packagesProvider.notifier)
        //     .loadCollectionFromSharedPreferences();

        // // Fetch and set the initial data
        // final servicePeopleState = ref.watch(servicePeopleProvider);
        // final showcaseState = ref.watch(showcaseProvider);
        // final packagesState = ref.watch(packagesProvider);
        // if (servicePeopleState.isEmpty ||
        //     showcaseState.isEmpty ||
        //     packagesState.isEmpty) {
        //   await fetchInitialCollections(ref);
        // }

        _goToScr('/BottomNav');
      } else {
        _goToScr('/IntroScr');
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text('Home Service'),
          const SizedBox(height: 179),

          Center(
            child: Opacity(
              opacity: 0.83,
              child: Image.asset(
                height: 89,
                'hs_assets/images/home_service.png',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 19.0),
            child: Opacity(
              opacity: 0.37,
              child: Lottie.asset(
                'hs_assets/animations/silver_bar.json',
                // width: 230,
                height: 165,
                repeat: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
