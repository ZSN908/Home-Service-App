import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_service/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/intros/intro_slides_screen.dart';
import 'screens/intros/splash_screen.dart';
import 'screens/auths/login_screen.dart';
import 'screens/auths/signup_screen.dart';
import 'screens/components/bottom_nav_bar.dart';
import 'screens/mains/booking_screen.dart';
import 'screens/mains/search_screen.dart';
import 'screens/mains/favorites.dart';
import 'screens/mains/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Service App',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          // Apply Google font globally [openSans] or [roboto] or [lato]
          Theme.of(context).textTheme,
        ),
        // Other theme configurations...
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/IntroScr': (context) => const IntroSlidesScreen(),
        '/LoginScr': (context) => const LoginScreen(),
        '/SignUpScr': (context) => const SignUpScreen(),
        '/BottomNav': (context) => const BottomNavBar(),
        '/Search': (context) => const SearchScreen(),
        '/Booking': (context) => const BookingScreen(),
        '/FavoritesScr': (context) => const FavoritesScreen(),
        '/NotificationScr': (context) => const NotificationScreen(),
      },
    );
  }
}


// -------------------<Remaining>-------------------
//   Bookings (Collection)
//    ├── title : String
//    ├── provider : String
//    ├── price : String
//    ├── size : String
//    ├── status : String
//    ├── paymethod : String
//    ├── reason : String
//    ├── createdAt : Timestamp


//  flutter clean 
//  flutter pub get
//  flutter pub outdated
//  flutter pub upgrade --major-versions
// cd android
// ./gradlew clean 
