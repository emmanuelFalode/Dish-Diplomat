import 'package:flutter/material.dart';
import 'package:foodapp/widgets/color_extension.dart';

class ViewAllTitleRows extends StatelessWidget {
  const ViewAllTitleRows({super.key, this.title, this.onView});

  final String? title;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            // color: Colors.orange,
          ),
        ),
        TextButton(
          onPressed: onView!,
          child: Text(
            "View All",
            style: TextStyle(
              color: Tcolor.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              // color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
