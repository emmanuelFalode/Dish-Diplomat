import 'package:flutter/material.dart';

class ProfileCat extends StatelessWidget {
  const ProfileCat({super.key, this.pObj, this.onTap});

  final Map? pObj;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                pObj!["images"].toString(),
                height: 85,
                width: 85,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 10),

            Text(
              textAlign: TextAlign.center,
              pObj!["name"],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
