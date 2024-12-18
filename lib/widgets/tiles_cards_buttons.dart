import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_service/screens/mains/details.dart';
import 'package:lottie/lottie.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String nextTitle;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final TextStyle textStyle;
  final TextStyle nextTextStyle;
  final double borderRadius;
  final double vertpadd;
  final double horipadd;
  final double btnHeight;
  final double btnWidth;

  const CustomButton({
    super.key,
    this.title = '',
    this.nextTitle = '',
    this.icon = Icons.abc,
    required this.onPressed,
    this.color = Colors.black,
    this.borderColor = Colors.black,
    this.textStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    this.nextTextStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    this.borderRadius = 30.0,
    this.vertpadd = 10,
    this.horipadd = 0,
    this.btnHeight = 0,
    this.btnWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight == 0 ? null : btnHeight,
      width: btnWidth == 0 ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
                color: borderColor, width: icon != Icons.abc ? 1 : 0),
          ),
          padding: EdgeInsets.symmetric(
              vertical: vertpadd,
              horizontal: (nextTitle == '' ? horipadd : 23)),
        ),
        onPressed: onPressed,
        child: title != ''
            ? Row(
                mainAxisAlignment: nextTitle == ''
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: textStyle,
                  ),
                  Text(
                    nextTitle,
                    style: nextTextStyle,
                  ),
                ],
              )
            : Icon(
                icon,
                size: 19,
                color: Colors.black,
              ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final bool iconBtn;
  final String title;
  final String nextTitle;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    this.iconBtn = false,
    this.title = '',
    this.nextTitle = '',
    this.icon = Icons.abc,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 25,
      minWidth: 59,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}

Widget customTitleRow({
  required String name,
  bool padd = true,
  bool elip = true,
  double size = 16.2,
  bool btn = false,
  void Function()? onPress,
  String buttonTitle = 'View All',
  required BuildContext context,
  bool short = false,
}) {
  return Padding(
    padding: EdgeInsets.only(left: padd ? 16.0 : 1.0, top: padd ? 0.0 : 8.0),
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: padd ? 9.0 : 0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * (short ? 0.6 : 0.9),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: padd ? 17.7 : size,
                    fontWeight: FontWeight.w600,
                    overflow: elip ? TextOverflow.ellipsis : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (btn)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: name == 'Combos And Subscriptions' ? 0 : 8.0),
                child: TextButton(
                  onPressed: onPress,
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

class OptionTile extends StatelessWidget {
  final bool isDrawer;
  final String title;
  final Icon relatedIcon;
  final void Function()? onClick;

  const OptionTile({
    super.key,
    required this.isDrawer,
    required this.title,
    required this.relatedIcon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isDrawer ? 15 : 0, vertical: isDrawer ? 6 : 0),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isDrawer ? 0 : 15, vertical: isDrawer ? 5.0 : 15.5),
          child: Row(
            mainAxisAlignment: isDrawer
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 29,
                    child: relatedIcon,
                  ),
                  Text(
                    ' $title',
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
              if (!isDrawer && title == 'My Profile')
                const SizedBox(
                  width: 29,
                  child: Icon(Icons.edit, size: 17),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavCard extends StatelessWidget {
  final String id;
  final String name;
  final String about;
  final String image;
  final double rating;
  final int jobs;
  final String price;
  final String service;
  final bool isFavorite;
  final VoidCallback toggleFavorite;

  const FavCard({
    super.key,
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.rating,
    required this.jobs,
    required this.price,
    required this.service,
    this.isFavorite = false,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(
                  id: id,
                  name: name,
                  image: image,
                  about: about,
                  jobs: jobs,
                  rating: rating,
                ),
              ),
            );
          },
          child: Container(
            height: 223,
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 143,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(9)),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => Center(
                      child: Opacity(
                        opacity: 0.70,
                        child: Lottie.asset(
                          'hs_assets/animations/mirrorIndicator.json',
                          width: 43,
                          height: 43,
                          repeat: true,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 19.7,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.7),
                          child: Text(
                            service,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber.withOpacity(0.7),
                              size: 19,
                            ),
                            Text(
                              ' $rating',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 110),
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 3.0),
                            child: Text(
                              "/hr  ",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
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
        ),
        SizedBox(
          height: 156,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3.0),
                      child: InkWell(
                        onTap: toggleFavorite,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white70,
                          child: Icon(
                            isFavorite
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            size: isFavorite ? 19 : 18,
                            color: isFavorite ? Colors.red : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 223,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: CustomButton(
                  title: 'Book',
                  btnHeight: 46.0,
                  btnWidth: 1,
                  horipadd: 50,
                  textStyle:
                      const TextStyle(color: Colors.white, fontSize: 14.3),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
