import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';
import 'package:lottie/lottie.dart';

class CancelBooking extends ConsumerStatefulWidget {
  final String title;
  final String image;
  final String provider;
  final String price;

  const CancelBooking({
    super.key,
    required this.title,
    required this.image,
    required this.provider,
    required this.price,
  });

  @override
  ConsumerState<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends ConsumerState<CancelBooking> {
  int _count = 1;
  String _refundMethod = '';
  String _cancellingReason = '';

  void _updateCount(bool inc) {
    if (_count >= 1) {
      setState(() {
        inc ? _count++ : _count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cancel Booking",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 3.0, vertical: 5.0),
                        padding: const EdgeInsets.all(14.0),
                        height: 175,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 237, 237, 237),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 69,
                                  width: 69,
                                  margin: const EdgeInsets.only(right: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.image,
                                    placeholder: (context, url) => Center(
                                      child: Opacity(
                                        opacity: 0.70,
                                        child: Lottie.asset(
                                          'hs_assets/animations/mirrorIndicator.json',
                                          width: 33,
                                          height: 33,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.43,
                                          child: Text(
                                            widget.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              height: 1.5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.provider,
                                      style: const TextStyle(
                                        fontSize: 12.7,
                                        color: Colors.grey,
                                        height: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                          size: 14,
                                        ),
                                        Text(
                                          " 6am",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          " on ",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "Thursday",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      "1590 Sqft",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "|",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "3BHK",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.price,
                                  style: const TextStyle(
                                    fontSize: 17.3,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 217,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 19.0),
                                  height: 38,
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_count > 1) {
                                            _updateCount(false);
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 9),
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                              child: Text(
                                            _count.toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _updateCount(true);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  customTitleRow(
                    name: 'Order Summary',
                    size: 18,
                    padd: false,
                    context: context,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subtotal",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          height: 2,
                        ),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GST",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          height: 2,
                        ),
                      ),
                      Text(
                        "Rs160",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coupon Discount",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          height: 2,
                        ),
                      ),
                      Text(
                        "- Rs160",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  customTitleRow(
                    name: 'Refund Method',
                    size: 18,
                    padd: false,
                    context: context,
                  ),
                  const SizedBox(height: 5),
                  _buildCustomRadio('Refund to Original Payment Method', true),
                  _buildCustomRadio('Add to My Wallet', true),
                  const SizedBox(height: 21),
                  customTitleRow(
                    name: 'Why are you cancelling this service',
                    size: 18,
                    padd: false,
                    elip: false,
                    context: context,
                  ),
                  const SizedBox(height: 5),
                  _buildCustomRadio('Booked by mistake', false),
                  _buildCustomRadio(
                      'Not available on the date of service', false),
                  _buildCustomRadio('No Longer needed', false),
                  const SizedBox(height: 59),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'Cancel Service',
                        btnHeight: 43.0,
                        btnWidth: 1,
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.3,
                            fontWeight: FontWeight.w700),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Custom Radio Button Method
  Widget _buildCustomRadio(String text, bool isFund) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          Radio<String>(
            value: text,
            groupValue: isFund ? _refundMethod : _cancellingReason,
            activeColor: Colors.orange,
            onChanged: (value) {
              setState(() {
                if (isFund) {
                  _refundMethod = value!;
                } else {
                  _cancellingReason = value!;
                }
              });
            },
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
