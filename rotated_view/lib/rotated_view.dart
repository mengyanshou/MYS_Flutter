library rotated_view;

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

//这就是一个具有惯性跟阻力的旋转控件
//可以选择使用传感器控制其旋转
//初学者不是很会简化代码
//多多见谅
class RotatedView extends StatefulWidget {
  final Widget child;
  final bool usesensor;
  final bool issame;
  final bool haveinertia;

  const RotatedView(
      {Key key,
        @required this.child,
        this.usesensor = false,
        this.issame = true,
        this.haveinertia = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _RotatedViewState(child, usesensor, issame, haveinertia);
}

var _angelvalue = 0.0;

class _RotatedViewState extends State<RotatedView>
    with TickerProviderStateMixin {
  Vector3 vector3;
  Size size;
  Velocity k;
  num _sensor;
  Widget _child;
  double _rotation = 0.0;
  double _tmpRotation = 0.0;
  double _tmp;
  double _height;
  double _width;
  AnimationController _animationController;
  Animation<double> _values;
  Offset _previous;
  Offset _now;
  double _change;
  int _a;
  double _v;
  double _v1;
  double _v2;
  Matrix4 matrix4;
  bool _usesensor;
  bool _issame;
  bool _haveinertia;

  _RotatedViewState(
      this._child, this._usesensor, this._issame, this._haveinertia);
  @override
  void initState() {
    _animationController ??=
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    super.initState();
  }

  void s() {
    AeyriumSensor.sensorEvents.listen((SensorEvent event) {
      if (_issame) {
        _sensor = -event.roll;
      } else {
        _sensor = event.roll;
      }
      //保存传感器插件传回来的Z轴的弧度变化
      _animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 100));
      _values = Tween(begin: 0.0, end: 1.0).animate(_animationController);
      //由于传感器数据在刚好超过π时会马上变为负值
      //所以写一下逻辑来避免一些动画过渡的Bug
      if (_sensor.abs() >= math.pi / 2) {
        //当倾斜弧度的绝对值大于π/2即90°用另一种方法计算当前的偏移位置
        if (_sensor >= 0) {
          _tmp = _angelvalue * math.pi / 180;
        }
        if (_sensor <= 0) {
          if (_angelvalue == 0.0) {
            _tmp = _angelvalue;
          } else {
            _tmp =
                _angelvalue * math.pi / 180 - 2 * math.pi; //将传感器值处于三四象限为负转化为正
          }
        }
        if (_sensor >= 0 && _tmp >= 0 || _sensor <= 0 && _tmp <= 0) {
          _change = _sensor - _tmp;
        }
        if (_sensor <= 0 && _tmp >= 0) {
          _change = 2 * math.pi - (_sensor - _tmp);
        }
      } else {
        _tmp = _rotation;
        _change = _sensor - _tmp;
      }
      _animationController.addListener(() {
        setState(() {
          _rotation = _tmp + _change * _values.value;
          //利用动画的值改变控件倾斜的角度
        });
      });
      if (!_animationController.isAnimating) {
        if (_a == 0) {
          _animationController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
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
    //布局构建完成后执行方法
    //只执行一次
    location(); //获取当前Widget的位置跟大小
  }

  Future<Null> location() async {
    await Future.delayed(Duration(milliseconds: 100), () {
      RenderObject renderObject = context.findRenderObject();
      size = renderObject.paintBounds.size;
      vector3 = renderObject.getTransformTo(null)?.getTranslation();
      if (_usesensor) {
        _a = 0;
        s();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 配置 Matrix
    matrix4 = Matrix4.identity()..rotateZ(_rotation);
    //每次调用SetState由这个来改变角度
    if (matrix4.entry(1, 0) >= 0 && matrix4.entry(0, 0) >= 0) {
      //第一象限
      _angelvalue = (math.asin(matrix4.entry(1, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) >= 0 && matrix4.entry(0, 0) <= 0) {
      //第二象限
      _angelvalue = (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) <= 0 && matrix4.entry(0, 0) <= 0) {
      //第三象限
      _angelvalue = 360 - (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
    }
    if (matrix4.entry(1, 0) < 0 && matrix4.entry(0, 0) > 0) {
      //第四象限
      _angelvalue = 360 - (math.acos(matrix4.entry(0, 0))) * 180 / math.pi;
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
                          if (_a == 0) {
                            _a = 1;
                          } else {
                            _a = 0;
                          }

                          if (_animationController.isAnimating) {
                            //点击停止上次事件的动画
                            _animationController.dispose();
                          }
                          _tmpRotation = _rotation;
                          double x1 = -(0.5 * size.width +
                              vector3.x -
                              details.globalPosition.dx);
                          double y1 =
                              0.5 * size.height + vector3.y - details.globalPosition.dy;
                          _previous = Offset(x1, y1);
                          //获取控件中心坐标并保存当前初始点击的点相对控件中心的坐标
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            double x = -(0.5 * size.width +
                                vector3.x -
                                details.globalPosition.dx);
                            double y = 0.5 * size.height +
                                vector3.y -
                                details.globalPosition.dy;
                            double angle1 = math.atan2(
                                _previous.dx, _previous.dy); //计算初始按下时相对控件中心的弧度值
                            double angle2 = math.atan2(x, y); //计算初始当前相对控件中心的弧度值
                            double angle3 = angle2 - angle1; //计算弧度值查
                            if (!_usesensor) {
                              _rotation = _tmpRotation + angle3; //改变当前的Z轴弧度偏移量
                            }
                            _now = Offset(x, y);
                            Future<Null> speed() async {
                              //避免手机滑动小于一秒的情况来计算每0.1s变化的角度
                              await Future.delayed(Duration(milliseconds: 0), () {
                                _v1 = _angelvalue;
                              });
                              await Future.delayed(Duration(milliseconds: 100), () {
                                _v2 = _angelvalue;
                                _v = _v2 - _v1;
                                //print(_v);
                              });
                            }

                            speed();
                            //用内部的延时进程计算控件转动的速度
                            //得到的V单位是°/(0.1s)
                          });
                        },
                        onPanEnd: (details) {
                          //控件的惯性旋转
                          //让控件以之前转动的速度稍大的速度为初速度继续旋转一秒
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 1));
                          final Animation curve = CurvedAnimation(
                              parent: _animationController, curve: Curves.ease);
                          //阻尼曲线
                          if (_haveinertia) {
                            _values = Tween(begin: 0.0, end: 1.0).animate(curve);
                          } else {
                            _values = Tween(begin: 0.0, end: 0.0).animate(curve);
                          }

                          _animationController.addListener(() {
                            setState(() {
                              // 通过动画逐帧还原位置
                              _rotation = _tmpRotation +
                                  (_v * math.pi / 180) * 11 * _values.value;
                            });
                          });
                          if (!_animationController.isAnimating) {
                            _tmpRotation = _rotation;
                            //_animationController.reset();
                            if (details.velocity.pixelsPerSecond == Offset(0.0, 0.0)) {
                              //避免手指不能绝对的相对屏幕不动加入一个逻辑
                              //避免一些Bug
                            } else {
                              _animationController.forward();
                            }
                          }
                        },
                        onDoubleTap: () {
                          //双击恢复默认位置
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 1));
                          final Animation curve1 = CurvedAnimation(
                              parent: _animationController, curve: Curves.ease);
                          _values = Tween(begin: 1.0, end: 0.0).animate(curve1);
                          _animationController.addListener(() {
                            setState(() {
                              // 通过动画逐帧还原位置
                              //始终选择小弧度恢复原来位置
                              _tmpRotation = _angelvalue * math.pi / 180;
                              if (_angelvalue <= 180.0) {
                                _rotation = _tmpRotation * _values.value;
                              } else {
                                _rotation =
                                    -(2 * math.pi - _tmpRotation) * _values.value;
                              }
                            });
                          });
                          if (!_animationController.isAnimating) {
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
                "值：" + _angelvalue.toInt().toString(),
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
