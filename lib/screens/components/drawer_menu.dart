import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/tiles_cards_buttons.dart';
import '/providers/auth_provider.dart';
import '/providers/user_provider.dart';
import '/screens/mains/profile.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  const DrawerMenu({super.key});

  @override
  ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {
  Future<void> handleLogout() async {
    // Navigator.pop(context);
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final result = await ref.read(authProvider.notifier).logout();
      if (result == 'User logged out successfully') {
        _goToScr('/');
      }
    }
  }

  void _goToScr(String scrIndex) {
    Navigator.pushReplacementNamed(context, scrIndex);
  }

  void navigateTo(String route, {Widget? screen}) {
    Navigator.pop(context);
    screen != null
        ? Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
        : Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    // Read the user data from the provider
    final userData = ref.watch(userProvider);
    return Drawer(
      backgroundColor: Colors.grey.shade50,
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            // padding: const EdgeInsets.only(left: 27.0, bottom: 20, top: 57),
            padding: const EdgeInsets.fromLTRB(27.0, 57.0, 27.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                      userData?.name.isNotEmpty == true
                          ? userData!.name[0].toUpperCase()
                          : "U",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                        ),
                      )),
                ),
                const SizedBox(height: 15),
                Text(
                  userData?.name ?? "User Name",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    height: 1.9,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  userData?.email ?? "useremail@example.com",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          OptionTile(
            isDrawer: true,
            title: 'My Profile',
            relatedIcon: const Icon(Icons.person, size: 21),
            onClick: () => navigateTo(
              '',
              screen: ProfileScreen(
                uId: FirebaseAuth.instance.currentUser?.uid ?? '',
                initialemail: userData?.email ?? '',
                initialName: userData?.name ?? '',
                initialAbout: userData?.about ?? '',
                initialImageUrl: userData?.profilePictureUrl ?? '',
              ),
            ),
          ),
          OptionTile(
            isDrawer: true,
            title: 'My Favorites',
            relatedIcon: const Icon(Icons.favorite, size: 20),
            onClick: () => navigateTo('/FavoritesScr'),
          ),
          OptionTile(
            isDrawer: true,
            title: 'Notifications',
            relatedIcon: const Icon(Icons.notifications, size: 21),
            onClick: () => navigateTo('/NotificationScr'),
          ),
          OptionTile(
            isDrawer: true,
            title: 'My Bookings',
            relatedIcon: const Icon(Icons.calendar_month, size: 21),
            onClick: () => navigateTo('/Booking'),
          ),
          OptionTile(
              isDrawer: true,
              title: 'Refer and Earn',
              relatedIcon: const Icon(Icons.monetization_on, size: 21),
              onClick: () {
                Navigator.pop(context);
              }),
          OptionTile(
              isDrawer: true,
              title: 'Contect us',
              relatedIcon: const Icon(Icons.mail, size: 20),
              onClick: () {
                Navigator.pop(context);
              }),
          OptionTile(
              isDrawer: true,
              title: 'Help Center',
              relatedIcon: const Icon(Icons.question_mark_outlined, size: 21),
              onClick: () {
                Navigator.pop(context);
              }),
          OptionTile(
            isDrawer: true,
            title: 'Logout',
            relatedIcon: const Icon(Icons.logout, size: 20),
            onClick: handleLogout,
          ),

          // const DrawerHeader(
          //   child:
          // ),
          // ListTile(
          //   leading: const Icon(Icons.account_circle),
          //   title: const Text("Account"),
          //   onTap: () {
          //     // Navigate to Account
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
