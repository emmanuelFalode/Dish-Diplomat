

import 'package:flutter/material.dart';

import 'package:foodapp/screens/onboarding/onboarding.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    goSignin();
  }

  void goSignin() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(context, MaterialPageRoute(builder: (e) => Onboarding()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/Bg Asset.png", fit: BoxFit.cover),
          Image.asset("assets/images/Logo.png"),
        ],
      ),
    );
  }
}
