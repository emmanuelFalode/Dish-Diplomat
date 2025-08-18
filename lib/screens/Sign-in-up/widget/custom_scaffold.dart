import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0xFF001628)),
          Image.asset(
            "assets/images/Bg2.png",
            fit: BoxFit.cover,
            color: Colors.grey,
          ),
          SafeArea(child: child!),
        ],
      ),
    );
  }
}
