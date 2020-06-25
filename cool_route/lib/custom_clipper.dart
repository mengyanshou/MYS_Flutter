import 'package:flutter/material.dart';

import 'circle_controller.dart';

class MyClipper extends CustomClipper<Path> {
  MyClipper({
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
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
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
  Path getClip(Size size) {
    Path path = Path();
    if (isEnd) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    path = getRightCirclePath();
    
    Path path2 = getLeftCirclePath();
    // if (leftEnd) {
    //   path2.addPath( Path()
    //         ..addOval(Rect.fromCenter(
    //           center: Offset(400, 400),
    //           width: 200,
    //           height: 200,
    //         )),Offset(0,0));

    //   // path.addOval(Rect.fromCenter(
    //   //     center: rightCircleCenter.translate(
    //   //         -rightCircleRadius + leftCircleRadius, 0),
    //   //     width: leftCircleRadius * 2,
    //   //     height: leftCircleRadius * 2));

    // }

    if (leftStart) {
      print('object');
      path.addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height));

      path = Path.combine(PathOperation.difference, path, path2);

      // path.
    }

    return path;
  }
}
