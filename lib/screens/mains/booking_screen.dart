import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:home_service/screens/mains/cancel_booking.dart';
import 'package:lottie/lottie.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Bookings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            tabs: [
              Tab(text: "Active"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ActiveBookingsPage(),
            HistoryBookingsPage(),
          ],
        ),
      ),
    );
  }
}

class ActiveBookingsPage extends StatelessWidget {
  const ActiveBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
            child: bookingCard(
              context: context,
              title: "Full House Cleaning",
              image:
                  "https://www.balajicleaningagency.com/img/service/Untitled-02.jpg",
              provider: 'Jaylon Cleaning Services',
              status: true,
              price: 'Rs5999',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
            child: bookingCard(
              context: context,
              title: "Sofa Cleaning",
              image:
                  "https://t3.ftcdn.net/jpg/08/92/98/12/360_F_892981269_fRpJdRPqUGEVwVQFIUGaVGmNLM3N7DRh.jpg",
              provider: 'Walton Cleaning Services',
              status: false,
              price: 'Rs2100',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 17),
            child: bookingCard(
              context: context,
              title: "Kitchen Cleaning",
              image:
                  "https://www.marthastewart.com/thmb/KEVbxgyysVUZQTpML5A-wNyi4nU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2V9A0229-Edit-937faa5ce0c6490a91d1f0dc3422a40f.jpg",
              provider: 'Sj Cleaning Services',
              status: false,
              price: 'Rs3000',
            ),
          ),

          // Center(
          //   child: Text(
          //     "Active Bookings",
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

class HistoryBookingsPage extends StatelessWidget {
  const HistoryBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
            child: bookingCard(
              context: context,
              isHistory: true,
              title: "Full House Cleaning",
              image:
                  "https://www.balajicleaningagency.com/img/service/Untitled-02.jpg",
              provider: 'Jaylon Cleaning Services',
              status: true,
              price: 'Rs2599',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
            child: bookingCard(
              context: context,
              isHistory: true,
              title: "Kitchen Cleaning",
              image:
                  "https://www.marthastewart.com/thmb/KEVbxgyysVUZQTpML5A-wNyi4nU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2V9A0229-Edit-937faa5ce0c6490a91d1f0dc3422a40f.jpg",
              provider: 'Sj Cleaning Services',
              status: false,
              price: 'Rs3000',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 17),
            child: bookingCard(
              context: context,
              isHistory: true,
              title: "Sofa Cleaning",
              image:
                  "https://t3.ftcdn.net/jpg/08/92/98/12/360_F_892981269_fRpJdRPqUGEVwVQFIUGaVGmNLM3N7DRh.jpg",
              provider: 'Walton Cleaning Services',
              status: false,
              price: 'Rs2100',
            ),
          ),

          // Center(
          //   child: Text(
          //     "Booking History",
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

Future<void> handleReBook(BuildContext context) async {
  final shouldReBook = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: const Text(
        'Are you sure to book that service again?',
        style: TextStyle(
          fontSize: 23,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes', style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );
  if (shouldReBook == true) {}
}

Widget bookingCard({
  required BuildContext context,
  bool isHistory = false,
  required String title,
  required String image,
  required String provider,
  required bool status,
  required String price,
}) {
  return InkWell(
    onTap: () {
      if (isHistory) {
        handleReBook(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CancelBooking(
              title: title,
              image: image,
              provider: provider,
              price: price,
            ),
          ),
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
      height: 223,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 237),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                isHistory
                    ? (status ? "Completed" : "Cancelled")
                    : (status ? "In Process" : "Assigned"),
                style: TextStyle(
                  fontSize: 16,
                  color: isHistory
                      ? (status ? Colors.green : Colors.red)
                      : (status ? Colors.orange : Colors.blue),
                  height: 1.7,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 3, top: 5),
                height: 43,
                width: 43,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Center(
                    child: Opacity(
                      opacity: 0.70,
                      child: Lottie.asset(
                        'hs_assets/animations/mirrorIndicator.json',
                        width: 30,
                        height: 30,
                        repeat: true,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      " $provider",
                      style: const TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.orange,
                        size: 18,
                      ),
                      Text(
                        " Jan 4,2022",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        " at ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        "4am",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.7,
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            isHistory ? "Book Again" : "Cancel",
            style: const TextStyle(
              fontSize: 16.7,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
              height: 1.7,
            ),
          ),
        ],
      ),
    ),
  );
}
