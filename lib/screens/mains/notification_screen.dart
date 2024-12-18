import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: 27,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: index == 26 ? 15 : 0,
                    left: 14.0,
                    right: 14.0,
                  ),
                  child: Container(
                    height: 68,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 9.5, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 237, 237),
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          spreadRadius: 0,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.ac_unit_rounded,
                          size: 22,
                          color: Color.fromARGB(187, 0, 0, 0),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: const Text(
                                "Home Hub",
                                style: TextStyle(
                                  fontSize: 14.3,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(217, 0, 0, 0),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: const Text(
                                "Thank You for order service using this app!",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Center(
          //   child: Text(
          //     "Notifications",
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w600,
          //       color: Colors.grey.shade300,
          //     ),
          //   ),
          // ),
          // Text(
          //   "Coming Soon...",
          //   style: TextStyle(
          //     fontSize: 15,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.grey.shade200,
          //   ),
          // ),
        ],
      ),
    );
  }
}
