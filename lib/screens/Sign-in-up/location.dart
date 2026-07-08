// import 'package:face_detector_plugin/face_detector_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Center(
                child: Image.asset(
                  "assets/images/location2.png",
                  fit: BoxFit.cover,
                  height: 300,
                  width: 200,
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/bottom');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Access Location",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.location_on),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),
            Text(
              textAlign: TextAlign.center,
              "We will access your location \n only while using the app",
              style: TextStyle(color: Colors.grey[600], fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
