import 'dart:math' as math;

import 'dart:ui';

class CircleController {
  CircleController.generateControllerPoints(
      Offset circelCenter, double circleRadius, double angle) {
    double h = (math.sqrt(2) - 1.0) * 4.0 / 3.0;
    h = h * circleRadius;
    // ------------------------------
    firstControllerPoints.add(Offset(
      circelCenter.dx - circleRadius,
      circelCenter.dy,
    ));
    firstControllerPoints.add(Offset(
      circelCenter.dx - circleRadius,
      circelCenter.dy - h,
    ));
    firstControllerPoints.add(
      rotateOffset(
        Offset(
          circelCenter.dx - h,
          circelCenter.dy - circleRadius,
        ),
        -angle,
        Offset(circelCenter.dx - circleRadius, circelCenter.dy - circleRadius),
      ),
    );
    firstControllerPoints.add(
      rotateOffset(
        Offset(
          circelCenter.dx,
          circelCenter.dy - circleRadius,
        ),
        -angle,
        Offset(circelCenter.dx - circleRadius, circelCenter.dy - circleRadius),
      ),
    );
    // ------------------------------
    secondControllerPoints.add(
      rotateOffset(
        Offset(
          circelCenter.dx,
          circelCenter.dy - circleRadius,
        ),
        angle,
        Offset(
          circelCenter.dx + circleRadius,
          circelCenter.dy - circleRadius,
        ),
      ),
    );
    secondControllerPoints.add(
      rotateOffset(
        Offset(
          circelCenter.dx + h,
          circelCenter.dy - circleRadius,
        ),
        angle,
        Offset(
          circelCenter.dx + circleRadius,
          circelCenter.dy - circleRadius,
        ),
      ),
    );
    secondControllerPoints.add(Offset(
      circelCenter.dx + circleRadius,
      circelCenter.dy - h,
    ));
    secondControllerPoints.add(Offset(
      circelCenter.dx + circleRadius,
      circelCenter.dy,
    ));
    // ------------------------------
    thirdControllerPoints.add(Offset(
      circelCenter.dx + circleRadius,
      circelCenter.dy,
    ));
    thirdControllerPoints.add(Offset(
      circelCenter.dx + circleRadius,
      circelCenter.dy + h,
    ));
    thirdControllerPoints.add(rotateOffset(
      Offset(
        circelCenter.dx + h,
        circelCenter.dy + circleRadius,
      ),
      -angle,
      Offset(
        circelCenter.dx + circleRadius,
        circelCenter.dy + circleRadius,
      ),
    ));
    thirdControllerPoints.add(rotateOffset(
      Offset(
        circelCenter.dx,
        circelCenter.dy + circleRadius,
      ),
      -angle,
      Offset(
        circelCenter.dx + circleRadius,
        circelCenter.dy + circleRadius,
      ),
    ));
    // ------------------------------
    fourthControllerPoints.add(rotateOffset(
      Offset(
        circelCenter.dx,
        circelCenter.dy + circleRadius,
      ),
      angle,
      Offset(circelCenter.dx - circleRadius, circelCenter.dy + circleRadius),
    ));
    fourthControllerPoints.add(rotateOffset(
      Offset(
        circelCenter.dx - h,
        circelCenter.dy + circleRadius,
      ),
      angle,
      Offset(circelCenter.dx - circleRadius, circelCenter.dy + circleRadius),
    ));
    fourthControllerPoints.add(Offset(
      circelCenter.dx - circleRadius,
      circelCenter.dy + h,
    ));
    fourthControllerPoints.add(Offset(
      circelCenter.dx - circleRadius,
      circelCenter.dy,
    ));
  }
  final List<Offset> firstControllerPoints = <Offset>[];
  final List<Offset> secondControllerPoints = <Offset>[];
  final List<Offset> thirdControllerPoints = <Offset>[];
  final List<Offset> fourthControllerPoints = <Offset>[];
  double getNegative(num number) {
    if (number.isNegative) {
      return -1;
    }
    return 1;
  }

  double getVectorInitAngle(Offset vector) {
    if (vector.dx == 0) {
      if (vector.dy > 0) {
        return math.pi / 2;
      } else {
        return math.pi * 3 / 2;
      }
    }
    if (vector.dy == 0) {
      if (vector.dx > 0) {
        return 0;
      } else {
        return math.pi;
      }
    }
    if (vector.dx > 0 && vector.dy > 0) {
      return math.atan2(vector.dx, vector.dy);
      // print(math.atan2(vector.dx, vector.dy) * 180 / math.pi);
    } else if (vector.dx < 0 && vector.dy > 0) {
      return math.atan2(vector.dx, vector.dy) + math.pi;
      // print(180 + math.atan2(vector.dx, vector.dy) * 180 / math.pi);
    } else if (vector.dx < 0 && vector.dy < 0) {
      return math.pi / 2 - math.atan2(vector.dx, vector.dy);
      // print(90 - math.atan2(vector.dx, vector.dy) * 180 / math.pi);
    } else if (vector.dx > 0 && vector.dy < 0) {
      return math.atan2(vector.dx, vector.dy) + math.pi;
      // print(180 + math.atan2(vector.dx, vector.dy) * 180 / math.pi);
    }
    return 0;
  }

  Offset rotateOffset(Offset point, double angle, [Offset origin]) {
    Offset tmp;
    origin ??= const Offset(0, 0);
    final Offset vector = point - origin;
    if (angle == 0.0) {
      return point;
    }
    print('vector====$vector===初始角度===>${getVectorInitAngle(vector)}');
    print('angle====${angle * 180 / math.pi}');
    tmp = Offset(
      origin.dx +
          vector.distance * math.cos(angle + getVectorInitAngle(vector)),
      origin.dy +
          vector.distance * math.sin(angle + getVectorInitAngle(vector)),
    );
    return tmp;
  }
}
