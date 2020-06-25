import 'dart:math' as math;
import 'dart:ui';

import 'package:coolroute/main.dart';
import 'package:flutter/material.dart';
import 'cool_route.dart';
import 'custom_canvas.dart';
import 'custom_clipper.dart';

class CoolButton extends StatefulWidget {
  const CoolButton({
    Key key,
    this.size = const Size(60, 60),
    @required this.buttonColor,
    @required this.nextButtonColor,
    @required this.pushPage,
    this.curPageAccentColor,
  }) : super(key: key);
  final Size size;
  final Color curPageAccentColor;
  final Color buttonColor;
  final Color nextButtonColor;
  final Widget pushPage;
  @override
  _CoolButtonState createState() => _CoolButtonState();
}

class _CoolButtonState extends State<CoolButton> {
  Color buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.buttonColor;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext iconContext) {
        return InkWell(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.size.width / 2)),
          onTap: () {
            buttonColor = Colors.transparent;
            setState(() {});
            final RenderBox renderBox =
                iconContext.findRenderObject() as RenderBox;
            Offset offset =
                renderBox.localToGlobal(renderBox.size.center(Offset.zero));
            offset = Offset(offset.dx - iconContext.size.width / 2,
                offset.dy - iconContext.size.height / 2);
            Navigator.push(
              context,
              CoolRoute(
                CoolAnimation(
                  curPageAccentColor: widget.curPageAccentColor,
                  buttonColor: widget.buttonColor,
                  nextButtonColor: widget.nextButtonColor,
                  iconOffset: offset,
                  iconSize: iconContext.size,
                  context: iconContext,
                  child: widget.pushPage,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.size.width / 2)),
            ),
            width: widget.size.width,
            height: widget.size.height,
          ),
        );
      },
    );
  }
}

class CoolAnimation extends StatefulWidget {
  const CoolAnimation({
    Key key,
    @required this.iconOffset,
    this.iconSize,
    this.context,
    this.buttonColor,
    this.child,
    this.nextButtonColor,
    this.curPageAccentColor,
  }) : super(key: key);
  final Color curPageAccentColor;
  final Offset iconOffset;
  final Size iconSize;
  final BuildContext context;
  final Color buttonColor;
  final Color nextButtonColor;
  final Widget child;

  @override
  _CoolAnimationState createState() => _CoolAnimationState();
}

class _CoolAnimationState extends State<CoolAnimation>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> rightCircleRadius;
  Animation<double> rightCircleAngle;
  Animation<double> leftCircleRadius;
  Animation<double> leftCircleAngle;

  AnimationController endAnimationCTL;
  Animation<double> move;
  double circleRadius;
  @override
  void initState() {
    super.initState();

    rightCircleRadius = AlwaysStoppedAnimation<double>(widget.iconSize.width);
    rightCircleAngle = const AlwaysStoppedAnimation<double>(0);
    leftCircleRadius = const AlwaysStoppedAnimation<double>(0);
    leftCircleAngle = const AlwaysStoppedAnimation<double>(0);
    initAnima();
  }

  void initAnima() {
    Offset point2 = Offset(MediaQuery.of(widget.context).size.width, 0);

    maxRadius = getRadius(widget.iconOffset, point2);
    print('maxRadius=======>>>>>${maxRadius}');
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    endAnimationCTL = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {});
      });
    rightCircleRadius = Tween<double>(
      begin: 30.0,
      // end: 100,
      end: maxRadius,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.25,
        ),
      ),
    );
    rightCircleAngle = Tween<double>(begin: 0, end: math.pi / 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.25,
          0.5,
        ),
      ),
    );
    leftCircleAngle = Tween<double>(begin: math.pi / 2, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.5,
          0.75,
          // curve: Curves.ease,
        ),
      ),
    );
    leftCircleRadius = Tween<double>(
      begin: maxRadius,
      // begin: 100,
      end: 30,
      // end: getRadius(point1, point2),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.75,
          1.0,
          // curve: Curves.ease,
        ),
      ),
    );
    execAnima();
  }

  Future<void> execAnima() async {
    animationController.addListener(() {
      setState(() {});
      // 我想用下面的代码来控制最后那个细节动画
      // 最后发现很难控制预期之外的效果
      if (animationController.value >= 1.0 && !endAnimationCTL.isAnimating) {
        endAnimationCTL.reset();
        endAnimationCTL.forward();
      }
    });
    animationController.reset();
    await animationController.forward();
  }

  double getRadius(
    Offset point1,
    Offset point2,
  ) {
    point1 = Offset(point1.dx, -point1.dy);
    point2 = Offset(point2.dx, -point2.dy);
    double r;
    final Offset line = point2 - point1;
    final double k = line.dy / line.dx;
    final double angle = math.atan(k);
    print('line向量坐标为====>$line');
    final double cosx = math.cos(angle);
    print('cosx====>$cosx');
    final double sinx = math.sin(angle);
    print('sinx====>$sinx');
    final double cos2x = math.pow(cosx, 2).toDouble() - math.pow(sinx, 2);
    final double l = line.distance;
    r = math.sqrt(math.pow(l, 2) / (2 * (1 + cos2x)));
    return r;
  }

  double maxRadius = 0;
  @override
  Widget build(BuildContext context) {
    // return Text('data');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: CustomPaint(
              //   willChange: true,
              //   painter: CoolCanvas(
              //      minRadius: widget.iconSize.width,
              //     leftEnd: animationController.isCompleted,
              //     buttonColor: widget.buttonColor,
              //     isEnd: endAnimationCTL.isCompleted,
              //     leftStart: animationController.value >= 0.5,
              //     maxRadius: maxRadius,
              //     rightCircleCenter: Offset(
              //       widget.iconOffset.dx + rightCircleRadius.value,
              //       widget.iconOffset.dy + widget.iconSize.height / 2,
              //     ),
              //     rightCircleAngle: rightCircleAngle.value,
              //     rightCircleRadius: rightCircleRadius.value,
              //     leftCircleCenter: Offset(
              //       widget.iconOffset.dx -
              //           leftCircleRadius.value +
              //           endAnimationCTL.value.toDouble() *
              //               widget.iconSize.width,
              //       widget.iconOffset.dy + widget.iconSize.height / 2,
              //     ),
              //     leftCircleAngle: leftCircleAngle.value,
              //     leftCircleRadius: leftCircleRadius.value,
              //   ),
              //   child: widget.child,
              // ),
              child: ClipPath(
                clipper: MyClipper(
                  minRadius: widget.iconSize.width,
                  leftEnd: animationController.isCompleted,
                  buttonColor: widget.buttonColor,
                  isEnd: animationController.isCompleted,
                  leftStart: animationController.value >= 0.5,
                  maxRadius: maxRadius,
                  rightCircleCenter: Offset(
                    widget.iconOffset.dx + rightCircleRadius.value,
                    widget.iconOffset.dy + widget.iconSize.height / 2,
                  ),
                  rightCircleAngle: rightCircleAngle.value,
                  rightCircleRadius: rightCircleRadius.value,
                  leftCircleCenter: Offset(
                    widget.iconOffset.dx - leftCircleRadius.value,
                    widget.iconOffset.dy + widget.iconSize.height / 2,
                  ),
                  leftCircleAngle: leftCircleAngle.value,
                  leftCircleRadius: leftCircleRadius.value -
                      endAnimationCTL.value * widget.iconSize.width / 2,
                ),
                child: widget.child,
              ),
            ),
          ),
          if (!endAnimationCTL.isCompleted)
            Positioned(
              left: widget.iconOffset.dx - 1,
              top: widget.iconOffset.dy - 1,
              child: SizedBox(
                width: widget.iconSize.width + 2,
                height: widget.iconSize.height + 2,
                child: ClipOval(
                  child: Container(
                    color: widget.buttonColor,
                  ),
                ),
              ),
            ),
          if (!endAnimationCTL.isCompleted)
            Positioned(
              left: widget.iconOffset.dx -
                  widget.iconSize.width +
                  endAnimationCTL.value * widget.iconSize.width,
              top: widget.iconOffset.dy,
              child: Padding(
                padding: EdgeInsets.all(0.0),
                child: SizedBox(
                  width: widget.iconSize.width,
                  height: widget.iconSize.height,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity(),
                    child: InkWell(
                      onTap: () async {
                        initAnima();
                      },
                      child: ClipOval(
                        child: Container(
                          color: widget.curPageAccentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!endAnimationCTL.isCompleted)
            Positioned(
              left: widget.iconOffset.dx - widget.iconSize.width,
              top: widget.iconOffset.dy,
              child: Padding(
                padding: EdgeInsets.only(
                  left:
                      endAnimationCTL.value.toDouble() * widget.iconSize.width,
                ),
                child: SizedBox(
                  width: widget.iconSize.width,
                  height: widget.iconSize.height,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..scale(endAnimationCTL.value),
                    child: InkWell(
                      onTap: () async {
                        initAnima();
                      },
                      child: ClipOval(
                        child: Container(
                          color: widget.nextButtonColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
