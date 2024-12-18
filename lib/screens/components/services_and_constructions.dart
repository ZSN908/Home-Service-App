import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/states_provider.dart';
import 'package:home_service/screens/mains/view_all.dart';
import 'package:home_service/widgets/tiles_cards_buttons.dart';

class ServicesAndConstructions extends ConsumerWidget {
  const ServicesAndConstructions({super.key});

  void _goToScr(BuildContext context, String optTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewAllScreen(
          title: optTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the string value from the provider
    final stringValue = ref.watch(serviceStateProvider);
    return Column(
      children: [
        /// Services
        customTitleRow(
            name: 'Home Services',
            btn: true,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ViewAllScreen(
                    title: 'Home Services',
                  ),
                ),
              );
            },
            context: context),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Plumber';
                  _goToScr(context, 'Plumber');
                },
                child: iconButton(
                    Icon(Icons.plumbing,
                        size: 28,
                        color: stringValue == 'Plumber'
                            ? Colors.white
                            : Colors.black),
                    'Plumber',
                    stringValue == 'Plumber' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Electrician';
                  _goToScr(context, 'Electrician');
                },
                child: iconButton(
                    Icon(Icons.cable_rounded,
                        size: 28,
                        color: stringValue == 'Electrician'
                            ? Colors.white
                            : Colors.black),
                    'Electrician',
                    stringValue == 'Electrician' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Painting';
                  _goToScr(context, 'Painter');
                },
                child: iconButton(
                    Icon(Icons.format_paint_rounded,
                        size: 28,
                        color: stringValue == 'Painting'
                            ? Colors.white
                            : Colors.black),
                    'Painting',
                    stringValue == 'Painting' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Carpenter';
                  _goToScr(context, 'Carpenter');
                },
                child: iconButton(
                    Icon(Icons.other_houses,
                        size: 27,
                        color: stringValue == 'Carpenter'
                            ? Colors.white
                            : Colors.black),
                    'Carpenter',
                    stringValue == 'Carpenter' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Cleaning';
                  _goToScr(context, 'Home Cleaner');
                },
                child: iconButton(
                    Icon(Icons.cleaning_services,
                        size: 28,
                        color: stringValue == 'Cleaning'
                            ? Colors.white
                            : Colors.black),
                    'Cleaning',
                    stringValue == 'Cleaning' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Car Washer';
                  _goToScr(context, 'Car Washer');
                },
                child: iconButton(
                    Icon(Icons.car_repair_outlined,
                        size: 28,
                        color: stringValue == 'Car Washer'
                            ? Colors.white
                            : Colors.black),
                    'Car Washer',
                    stringValue == 'Car Washer' ? true : false),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(serviceStateProvider.notifier).state = 'Car expert';
                  _goToScr(context, 'Car Repair');
                },
                child: iconButton(
                    Icon(Icons.home_repair_service,
                        size: 28,
                        color: stringValue == 'Car experts'
                            ? Colors.white
                            : Colors.black),
                    'Car experts',
                    stringValue == 'Car experts' ? true : false),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),

        const SizedBox(height: 17),

        /// Constructions
        customTitleRow(
          name: 'Home Construction',
          btn: true,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ViewAllScreen(
                  title: 'Home Construction',
                  isProviderList: false,
                ),
              ),
            );
          },
          context: context,
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 8),
              iconButton(
                  const Icon(Icons.construction, size: 28, color: Colors.black),
                  'Construction',
                  false),
              iconButton(
                  const Icon(Icons.architecture, size: 28, color: Colors.black),
                  'Architects',
                  false),
              iconButton(
                  const Icon(Icons.house_siding, size: 28, color: Colors.black),
                  'Interior design',
                  false),
              iconButton(
                  const Icon(Icons.vertical_split_rounded,
                      size: 28, color: Colors.black),
                  'Furniture',
                  false),
              iconButton(
                  const Icon(Icons.person, size: 28, color: Colors.black),
                  'Contractor',
                  false),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget iconButton(Icon buttonIcon, String name, bool activeStatus) {
    // Set color based on whether the indicator is active
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 29.5,
            backgroundColor:
                activeStatus ? Colors.black : Colors.grey.withOpacity(0.1),
            child: buttonIcon,
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: const TextStyle(fontSize: 13.7),
          ),
        ],
      ),
    );
  }
}
