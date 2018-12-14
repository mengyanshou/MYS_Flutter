import 'package:flutter/material.dart';
import 'MYSPage.2.dart';
import 'MYSPage.1.dart';
import 'MYSPage.3.dart';

void main() {
  runApp(MYS());
}

class MYS extends StatefulWidget {
  @override
  _MYSState createState() => _MYSState();
}

class _MYSState extends State<MYS> with SingleTickerProviderStateMixin {
  TabController _mysTabController;

  @override
  void initState() {
    _mysTabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    _mysTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("MYSTab"),
          bottom: TabBar(
            controller: _mysTabController,
            tabs: <Widget>[
              Text("第一个Tab"),
              Text("第二个Tab"),
              Text("第三个Tab"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _mysTabController,
          children: <Widget>[
            MYSPage1(),
            MYSPage2(),
            MYSPage3(),
          ],
        ),
      ),
    );
  }
}
