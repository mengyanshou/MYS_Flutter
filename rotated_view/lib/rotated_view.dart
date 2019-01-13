library rotated_view;
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;


class RotatedView extends StatefulWidget {
  final Widget child;

  const RotatedView({Key key, @required this.child}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _RotatedViewState(child);
}

var d = 0.0;

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t);
  }
}
class _RotatedViewState extends State<RotatedView>
    with TickerProviderStateMixin {
  PointerEvent event;
  Vector3 vector3;
  Size size;
  Velocity k;
  static final DPI = const EventChannel('Third3');
  num _DPI;
  StreamSubscription _subscription;
  Widget _child;

  /// A queue to sort pointers in order of entrance
  double _rotation = 0.0;
  double _tmpRotation = 0.0;
  double _tmp;
  double height;
  double width;
  AnimationController _animationController;
  Animation<double> _values;
  Offset previous;
  Offset now;
  double c;
  int a;
  double v;
  double v1;
  double v2;
  Matrix4 matrix4;
  RenderObject renderObject;

  _RotatedViewState( this._child);

  @override
  void initState() {
    _animationController ??=
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();

  }



  void s() {
    AeyriumSensor.sensorEvents.listen((SensorEvent event) {
      //do something with the event , values expressed in radians
      _DPI=-event.roll;
      //print("Pitch ${event.pitch} and Roll ${event.roll}");
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 100));
      _values = Tween(begin: 0.0, end: 1.0).animate(_animationController);
      if (_DPI.abs() >= math.pi / 2) {
        if (_DPI >= 0) {
          _tmp = d * math.pi / 180;
        }
        if (_DPI <= 0) {
          if (d == 0.0) {
            _tmp = d;
          } else {
            _tmp = d * math.pi / 180 - 2 * math.pi;
          }
          print(_tmp);
        }
        if (_DPI >= 0 && _tmp >= 0) {
          c = _DPI - _tmp;
        }
        if (_DPI <= 0 && _tmp <= 0) {
          c = _DPI - _tmp;
          //print(c);
        }
        if (_DPI <= 0 && _tmp >= 0) {
          c = 2 * math.pi - (_DPI - _tmp);
          //print(c);
        }
      } else {
        _tmp = _rotation;
        c = _DPI - _tmp;
      }
      _animationController.addListener(() {
        setState(() {
          _rotation = _tmp + c * _values.value;
        });
      });
      if (!_animationController.isAnimating) {
        if(a==0){
          _animationController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(RotatedView oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didUpdateWidget(oldWidget);
  }

  void _onAfterRendering(Duration timeStamp) {
    speed1();
    //这里编写获取元素大小和位置的方法
  }

  Future<Null> speed1() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      renderObject = context.findRenderObject();
      size = renderObject.paintBounds.size;
      vector3 = renderObject.getTransformTo(null)?.getTranslation();
      print(vector3.y);
      print(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 配置 Matrix
    matrix4 = Matrix4.identity()..rotateZ(_rotation);
    //print(matrix4);
//    print(math.atan2(0, -1));
//    print(math.acos(matrix4.entry(0, 0)));
    Future<Null> speed() async {
      await Future.delayed(Duration(milliseconds: 0), () {
        //_tmp = d*math.pi/180;
        //print(d*math.pi/180);
      });
    }

    speed();
    if (matrix4.entry(1, 0) >= 0 && matrix4.entry(0, 0) >= 0) {
      //第一象限
      d = (math.asin(matrix4.entry(1, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) >= 0 && matrix4.entry(0, 0) <= 0) {
      //第二象限
      d = (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) <= 0 && matrix4.entry(0, 0) <= 0) {
      //第三象限
      d = 360 - (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) < 0 && matrix4.entry(0, 0) > 0) {
      //第四象限
      d = 360 - (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
    }
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: matrix4,
                    child: GestureDetector(
                        onPanDown: (details) {
                          a=1;
                          if (_animationController.isAnimating) {
                            _animationController.dispose();
                          }
                          _tmpRotation = _rotation;
                          double x1 = -(0.5 * size.width - details.globalPosition.dx);
                          double y1 =
                              0.5 * size.height + vector3.y - details.globalPosition.dy;
                          previous = Offset(x1, y1);
                          //print(previous);
                        },
                        onPanEnd: (details) {
                          _tmpRotation = _rotation;
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 1));

                          final Animation curve1 = CurvedAnimation(
                              parent: _animationController, curve: Curves.ease);
                          _values = Tween(begin: 0.0, end: 1.0).animate(curve1);
                          _animationController.addListener(() {
                            setState(() {
                              // 通过动画逐帧还原位置
                              //print(_values.value);

                              _rotation = _tmpRotation + v / 5 * _values.value;
                              //_rotation = 2*math.pi;
                            });
                          });
                          if (!_animationController.isAnimating) {
                            _tmpRotation = _rotation;
                            print(details.velocity.pixelsPerSecond);
                            //_animationController.reset();
                            if (details.velocity.pixelsPerSecond == Offset(0.0, 0.0)) {
                              _tmp = d * math.pi / 180;
                              print(_tmp);
                            } else {
                              _animationController.forward();
                            }
                          }
                        },
                        onPanUpdate: (details) {
                          Future<Null> speed() async {
                            await Future.delayed(Duration(milliseconds: 0), () {
                              v1 = d;
                            });
                            await Future.delayed(Duration(milliseconds: 100), () {
                              v2 = d;
                              v = v2 - v1;
                              print(v);
                            });
                          }

                          speed();
                          setState(() {
                            double x = -(0.5 * size.width - details.globalPosition.dx);
                            double y = 0.5 * size.height +
                                vector3.y -
                                details.globalPosition.dy;
                            double angle1 = math.atan2(previous.dx, previous.dy);
                            double angle2 = math.atan2(x, y);
                            double angle3 = angle2 - angle1;
                            _rotation = _tmpRotation + angle3;
                            now = Offset(x, y);
                          });
                        },
                        onLongPress: () {
                          a=0;
                          s();
                        },
                        onDoubleTap: () {
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 1));
                          final Animation curve1 = CurvedAnimation(
                              parent: _animationController, curve: Curves.ease);
                          _values = Tween(begin: 1.0, end: 0.0).animate(curve1);
                          _animationController.addListener(() {
                            setState(() {
                              if (d <= 180.0) {
                                _tmpRotation = d * math.pi / 180;
                                _rotation = _tmpRotation * _values.value;
                              } else {
                                _tmpRotation = d * math.pi / 180;
                                _rotation =
                                    -(2 * math.pi - _tmpRotation) * _values.value;
                              }
                              // 通过动画逐帧还原位置
                            });
                          });
                          if (!_animationController.isAnimating) {
                            _tmpRotation = _rotation;
                            _animationController.reset();
                            _animationController.forward();
                          }
                        },
                        child: _child),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "值："+d.toInt().toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ));
  }
}
