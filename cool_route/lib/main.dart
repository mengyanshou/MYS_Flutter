import 'package:flutter/material.dart';

import 'animat_example.dart';
import 'cool_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageOne(),
    );
  }
}

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  Color buttonColor = Color(0xfffcb7d6);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff013bca),
      body: Stack(
        children: [
          Center(
            child: Text('页面1'),
          ),
          Align(
              alignment: Alignment(0, 0.5),
              child: CoolButton(
                curPageAccentColor: Color(0xff013bca),
                buttonColor: Color(0xfffcb7d6),
                nextButtonColor: Colors.white,
                pushPage: PageTwo(),
              )),
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcb7d6),
      body: Stack(
        children: [
          Center(
            child: Text('页面2'),
          ),
          Align(
              alignment: Alignment(0, 0.5),
              child: CoolButton(
                curPageAccentColor: Color(0xfffcb7d6),
                buttonColor: Colors.white,
                nextButtonColor: Colors.green,
                pushPage: PageThree(),
              )),
        ],
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Text('页面3'),
          ),
          Align(
              alignment: Alignment(0, 0.5),
              child: CoolButton(
                curPageAccentColor: Colors.white,
                buttonColor: Colors.green,
                nextButtonColor: Colors.red,
                pushPage: PageFour(),
              )),
        ],
      ),
    );
  }
}

class PageFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          Center(
            child: Text('页面4'),
          ),
          Align(
              alignment: Alignment(0, 0.5),
              child: CoolButton(
                curPageAccentColor: Colors.green,
                buttonColor: Colors.red,
                nextButtonColor: Colors.red,
                pushPage: PageTwo(),
              )),
        ],
      ),
    );
  }
}
