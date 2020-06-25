import 'dart:ui';

import 'package:flutter/material.dart';

import 'circle_controller.dart';

class CoolCanvas extends CustomPainter {
  CoolCanvas({
    this.minRadius,
    this.leftEnd,
    this.buttonColor = const Color(0xff811016),
    this.isEnd = false,
    this.leftStart = false,
    this.maxRadius,
    this.rightCircleAngle,
    this.rightCircleCenter,
    this.rightCircleRadius,
    this.leftCircleAngle,
    this.leftCircleCenter,
    this.leftCircleRadius,
  }) {
    _gridPaint = Paint()..style = PaintingStyle.stroke;
    _gridPath = Path();
  }

  final bool isEnd;
  final bool leftStart;

  final bool leftEnd;

  final double minRadius;
  final double maxRadius;
  final double rightCircleAngle;
  final Offset rightCircleCenter;
  final double rightCircleRadius;
  final double leftCircleAngle;
  final Offset leftCircleCenter;
  final double leftCircleRadius;

  final Color buttonColor;
  Paint _gridPaint;
  Path _gridPath;
  Path getCirclePath(CircleController controller) {
    final Path path = Path();
    path.moveTo(
      controller.firstControllerPoints[0].dx,
      controller.firstControllerPoints[0].dy,
    );
    path.cubicTo(
      controller.firstControllerPoints[1].dx,
      controller.firstControllerPoints[1].dy,
      controller.firstControllerPoints[2].dx,
      controller.firstControllerPoints[2].dy,
      controller.firstControllerPoints[3].dx,
      controller.firstControllerPoints[3].dy,
    );
    path.quadraticBezierTo(
      controller.firstControllerPoints[3].dx,
      controller.firstControllerPoints[3].dy,
      controller.secondControllerPoints[0].dx,
      controller.secondControllerPoints[0].dy,
    );
    path.cubicTo(
      controller.secondControllerPoints[1].dx,
      controller.secondControllerPoints[1].dy,
      controller.secondControllerPoints[2].dx,
      controller.secondControllerPoints[2].dy,
      controller.secondControllerPoints[3].dx,
      controller.secondControllerPoints[3].dy,
    );
    path.cubicTo(
      controller.thirdControllerPoints[1].dx,
      controller.thirdControllerPoints[1].dy,
      controller.thirdControllerPoints[2].dx,
      controller.thirdControllerPoints[2].dy,
      controller.thirdControllerPoints[3].dx,
      controller.thirdControllerPoints[3].dy,
    );
    path.quadraticBezierTo(
      controller.thirdControllerPoints[3].dx,
      controller.thirdControllerPoints[3].dy,
      controller.fourthControllerPoints[0].dx,
      controller.fourthControllerPoints[0].dy,
    );
    path.cubicTo(
      controller.fourthControllerPoints[1].dx,
      controller.fourthControllerPoints[1].dy,
      controller.fourthControllerPoints[2].dx,
      controller.fourthControllerPoints[2].dy,
      controller.fourthControllerPoints[3].dx,
      controller.fourthControllerPoints[3].dy,
    );

    return path;
  }

  Path getRightCirclePath() {
    final CircleController rightController =
        CircleController.generateControllerPoints(
      rightCircleCenter,
      rightCircleRadius,
      rightCircleAngle,
    );
    return getCirclePath(rightController);
  }

  Path getLeftCirclePath() {
    final CircleController leftController =
        CircleController.generateControllerPoints(
      leftCircleCenter,
      leftCircleRadius,
      leftCircleAngle,
    );
    return getCirclePath(leftController);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.translate(size.width / 2, size.height / 2);

    _drawGrid(canvas, size); //绘制格线
    _drawAxis(canvas, size); //绘制轴线
    canvas.translate(-size.width / 2, -size.height / 2);
    Path path = Path();
    // if (isEnd) {
    //   canvas.drawPath(
    //       Path()
    //         ..addRect(Rect.fromCenter(
    //             center: leftCircleCenter,
    //             width: maxRadius * 2,
    //             height: maxRadius * 2)),
    //       Paint()
    //         ..color = Colors.green
    //         ..strokeCap = StrokeCap.round
    //         ..style = PaintingStyle.fill
    //         ..strokeWidth = 2
    //         ..isAntiAlias = true);

    //   return;
    // }

    path = getRightCirclePath();
    Path path2 = getLeftCirclePath();
    if (leftStart) {
      print('object');
      path.addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height));
      path = Path.combine(PathOperation.xor, path, path2);
    }

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.red
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..isAntiAlias = true);

    // canvas.drawPoints(
    //     PointMode.points,
    //     rightController.firstControllerPoints,
    //     Paint()
    //       ..color = const Color(0xff811016)
    //       ..strokeCap = StrokeCap.round
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 8
    //       ..isAntiAlias = true);
    // canvas.drawPoints(
    //     PointMode.points,
    //     rightController.secondControllerPoints,
    //     Paint()
    //       ..color = const Color(0xff811016)
    //       ..strokeCap = StrokeCap.round
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 8
    //       ..isAntiAlias = true);
    // canvas.drawPoints(
    //     PointMode.points,
    //     rightController.thirdControllerPoints,
    //     Paint()
    //       ..color = const Color(0xff811016)
    //       ..strokeCap = StrokeCap.round
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 8
    //       ..isAntiAlias = true);
    // canvas.drawPoints(
    //     PointMode.points,
    //     rightController.fourthControllerPoints,
    //     Paint()
    //       ..color = const Color(0xff811016)
    //       ..strokeCap = StrokeCap.round
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 8
    //       ..isAntiAlias = true);
  }

  void _drawGrid(Canvas canvas, Size size) {
    _gridPaint
      ..color = Colors.grey
      ..strokeWidth = 0.5;
    _gridPath = _buildGridPath(_gridPath, size);
    canvas.drawPath(_buildGridPath(_gridPath, size), _gridPaint);

    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();
  }

  void _drawAxis(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.lines,
        [
          Offset(-size.width / 2, 0),
          Offset(size.width / 2, 0),
          Offset(0, -size.height / 2),
          Offset(0, size.height / 2),
          Offset(0, size.height / 2),
          Offset(0 - 7.0, size.height / 2 - 10),
          Offset(0, size.height / 2),
          Offset(0 + 7.0, size.height / 2 - 10),
          Offset(size.width / 2, 0),
          Offset(size.width / 2 - 10, 7),
          Offset(size.width / 2, 0),
          Offset(size.width / 2 - 10, -7),
        ],
        _gridPaint
          ..color = Colors.blue
          ..strokeWidth = 1.5);
  }

  Path _buildGridPath(Path path, Size size, {double step = 20.0}) {
    for (int i = 0; i < size.height / 2 / step; i++) {
      path.moveTo(0, step * i);
      path.relativeLineTo(size.width / 2, 0);
    }
    for (int i = 0; i < size.width / 2 / step; i++) {
      path.moveTo(step * i, 0);
      path.relativeLineTo(
        0,
        size.height / 2,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
