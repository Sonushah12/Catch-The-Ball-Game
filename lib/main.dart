import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  debugPrintEndFrameBanner = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text('Catch the Ball Game'),
          centerTitle: true,
        ),
        body: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double ballX = 0;
  double ballY = 0;
  double playerX = 0;
  double screenHeight = 0;
  double screenWidth = 0;

  void movePlayer(double dx) {
    setState(() {
      playerX = dx;
    });
  }

  void dropBall() {
    setState(() {
      ballX = Random().nextDouble() * screenWidth;
      ballY = 0;
    });
  }

  void checkCollision() {
    if ((ballY > screenHeight - 50) && (ballX >= playerX && ballX <= playerX + 50)) {
      dropBall();
    }
  }

  @override
  void initState() {
    super.initState();
    // Add a post-frame callback to access MediaQuery after initState is completed
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
      });
      dropBall();
    });
    // Create a timer to control ball movement
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        ballY += 5;
        checkCollision();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        movePlayer(playerX + details.delta.dx);
      },
      child: Stack(
        children: [
          Container(
            color: Colors.amber,
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                margin: EdgeInsets.only(
                  top: ballY,
                  left: ballX,
                ),
              ),
            ),
          ),
          Positioned(
            left: playerX,
            bottom: 0,
            child: Container(
              width: 50,
              height: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
