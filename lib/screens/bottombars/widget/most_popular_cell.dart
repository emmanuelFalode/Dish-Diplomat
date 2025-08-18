import 'package:flutter/material.dart';
import 'package:foodapp/widgets/color_extension.dart';

class MostPopularCell extends StatelessWidget {
  const MostPopularCell({super.key, this.cObj, this.onTap});

  final Map? cObj;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                cObj!["image"].toString(),
                width: 220,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              cObj!["name"],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  cObj!["type"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Text(
                  " . ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  cObj!["food_type"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 8),

                Icon(Icons.star, size: 15, color: Tcolor.primary),
                SizedBox(width: 4),
                Text(
                  cObj!["rate"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Tcolor.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
