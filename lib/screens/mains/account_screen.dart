import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:home_service/screens/mains/profile.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the user data from the provider
    final userData = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (userData == null || userData.profilePictureUrl == '')
                      ? Image.asset(
                          height: 87,
                          width: 87,
                          'hs_assets/images/defaultProfile.png',
                          fit: BoxFit.cover,
                        )
                      : SizedBox(
                          height: 87,
                          width: 87,
                          child: CachedNetworkImage(
                            imageUrl: userData.profilePictureUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5),
              child: Text(
                userData == null ? "user name" : userData.name,
                style: const TextStyle(
                  fontSize: 19.7,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              userData == null ? "useremail@example.com" : userData.email,
              style: const TextStyle(
                fontSize: 12.3,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 17),
            OptionTile(
                isDrawer: false,
                title: 'My Profile',
                relatedIcon: const Icon(Icons.person, size: 21),
                onClick: () {
                  // print('Ok Checkout list here:${userData?.favorites}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        uId: FirebaseAuth.instance.currentUser?.uid ?? '',
                        initialemail: userData?.email ?? '',
                        initialName: userData?.name ?? '',
                        initialAbout: userData?.about ?? '',
                        initialImageUrl: userData?.profilePictureUrl ?? '',
                      ),
                    ),
                  );
                }),
            OptionTile(
                isDrawer: false,
                title: 'My Favorites',
                relatedIcon: const Icon(Icons.favorite, size: 20),
                onClick: () {
                  Navigator.pushNamed(context, '/FavoritesScr');
                }),
            OptionTile(
                isDrawer: false,
                title: 'Notifications',
                relatedIcon: const Icon(Icons.notifications, size: 20),
                onClick: () {
                  Navigator.pushNamed(context, '/NotificationScr');
                }),
            OptionTile(
                isDrawer: false,
                title: 'My Bookings',
                relatedIcon: const Icon(Icons.calendar_month, size: 20),
                onClick: () {
                  Navigator.pushNamed(context, '/Booking');
                }),
            OptionTile(
                isDrawer: false,
                title: 'Refer and Earn',
                relatedIcon: const Icon(Icons.monetization_on, size: 21),
                onClick: () {}),
            OptionTile(
                isDrawer: false,
                title: 'Contact Us',
                relatedIcon: const Icon(Icons.mail, size: 20),
                onClick: () {}),
            OptionTile(
                isDrawer: false,
                title: 'Help Center',
                relatedIcon: const Icon(Icons.question_mark_outlined, size: 20),
                onClick: () {}),
            OptionTile(
                isDrawer: false,
                title: 'Offers And Coupons',
                relatedIcon: const Icon(Icons.local_offer, size: 21),
                onClick: () {}),
          ],
        ),
      ),
    );
  }
}
