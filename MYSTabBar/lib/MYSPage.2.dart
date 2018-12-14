import 'package:flutter/material.dart';

class MYSPage2 extends StatefulWidget {
  @override
  _MYSPage2State createState() => _MYSPage2State();
}

int a;
double b;

class _MYSPage2State extends State<MYSPage2> {
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    a ??= 0;//如果a的值为空让a=0
    b ??= 0;//如果b的值为空让a=0
    _controller.addListener(() {
      b=_controller.offset;////当Scroll开始滑动时随时把当前滑动的位置赋值给b
    });
    dleRefresh();//initState刷新立刻跳转上一次的滑动位置
  }

  Future<Null> dleRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      setState(() {});
      _controller.animateTo(b,
          duration: Duration(milliseconds: 1000),//跳转过去的时间
          curve: Curves.ease
      );
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _firstPage();
  }

  _firstPage() {
    if (a == 0) {
      return ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                a = 1;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "第二个页面的按钮",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    if (a == 1) {
      return WillPopScope(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: 100,
              itemExtent: 50.0, //列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
              controller: _controller,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("$index"),
                );
              },
            ),
          ),
          onWillPop: () {
            setState(() {
              a = 0;
            });
          });
    }
  }
}
