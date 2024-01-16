import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Marry Me?',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double top = 100;
  double right = 100;
  bool saidYes = false;

  Size btnSize = const Size(200, 110);

  ConfettiController confettiController = ConfettiController();

  @override
  void didChangeDependencies() {
    setState(() {
      top = MediaQuery.of(context).size.width * .22;
      right = MediaQuery.of(context).size.width * .25;
    });
    super.didChangeDependencies();
  }

  String questionText() {
    String data = 'He: Will you Marry me?';
    if (saidYes) {
      data += '\nShe: Yes, I will!';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(questionText(),
                  style: TextStyle(
                    fontSize: context.layout.value(xs: 25, md: 48, lg: 60),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.8,
                  )),
            ),
          ),
          if (!saidYes) ...[
            Positioned(
              top: size.width * .22,
              left: size.width * .25,
              child: CustomButton(
                title: 'Yes',
                onPressed: () {
                  setState(() {
                    saidYes = true;
                    confettiController.play();
                  });
                },
              ),
            ),
            Positioned(
              top: top,
              right: right,
              // right: 100,
              // bottom: 100,
              child: CustomButton(
                title: 'No',
                onPressed: () {
                  changePosition();
                },
                onHover: (value) {
                  if (value) {
                    changePosition();
                  }
                },
              ),
            ),
          ],
          Center(
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              blastDirection: -pi / 2,
            ),
          )
        ],
      ),
    );
  }

  //function to generate random number with in range
  double generateRandomNumber(double min, double max) {
    final Random random = Random();
    return min + random.nextDouble() * (max - min);
  }

  //function to change position of button
  void changePosition() {
    var media = MediaQuery.of(context);
    setState(() {
      right = generateRandomNumber(0, media.size.width - btnSize.width);
      top = generateRandomNumber(0, media.size.height - btnSize.height);
    });
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.onHover,
  });
  final String title;
  final VoidCallback? onPressed;
  final void Function(bool)? onHover;

  @override
  Widget build(BuildContext context) {
    Size btnSize = const Size(200, 110);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: btnSize,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white.withOpacity(0.8),
        textStyle: TextStyle(
          fontSize: context.layout.value(xs: 25, md: 48, lg: 60),
        ),
        // padding: const EdgeInsets.symmetric(
        //     horizontal: 16.0, vertical: 8.0)
      ),
      onHover: onHover,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
