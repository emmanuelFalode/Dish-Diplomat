import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.avi});

  final Map? avi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              avi!["images"].toString(),
              height: 85,
              width: 85,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
