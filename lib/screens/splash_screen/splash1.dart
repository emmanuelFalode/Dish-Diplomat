import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    super.initState();
    splash();
  }

  void splash() async {
    await Future.delayed(Duration(seconds: 3));
    context.go("/splash_view");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Image.asset("assets/images/Logo.png"))],
      ),
    );
  }
}
