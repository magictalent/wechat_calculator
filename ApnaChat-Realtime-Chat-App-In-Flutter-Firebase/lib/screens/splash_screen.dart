
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main.dart';
import 'calculator_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: Colors.black));

      //navigate to calculator screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CalculatorScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      //body
      body: Stack(children: [
        //calculator icon
        Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.calculate_rounded,
                size: 120,
                color: Colors.orange,
              ),
            )),

        //app name
        Positioned(
            top: mq.height * .5,
            width: mq.width,
            child: const Text('Calculator',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1))),

        //bottom text
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text('Your Digital Calculator',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.grey[400], letterSpacing: .5))),
      ]),
    );
  }
}
