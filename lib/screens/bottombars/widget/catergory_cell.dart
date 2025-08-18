import 'package:flutter/material.dart';
import 'package:foodapp/widgets/color_extension.dart';

class CatergoryCell extends StatelessWidget {
  const CatergoryCell({super.key, this.cObj, this.onTap});

  final Map? cObj;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap!,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                cObj!["image"].toString(),
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),

            Text(
              cObj!["name"],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
