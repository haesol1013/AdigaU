import 'package:flutter/material.dart';

class Catagory extends StatelessWidget {
  final String name, imgPath;

  const Catagory({
    super.key,
    required this.name,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 50,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            imgPath,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(name)
      ],
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(50, 13, 50, 50);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
