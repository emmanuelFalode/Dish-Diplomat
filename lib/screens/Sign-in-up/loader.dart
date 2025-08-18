import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});
  static show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(child: LoadingSpinner()),
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.7),

      barrierDismissible: false,
    );
  }

  static close(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 5),
              ),
            ],
          ),
          Center(child: Text("Please wait ...")),
        ],
      ),
    );
  }
}
