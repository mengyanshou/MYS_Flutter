
import 'package:flutter/material.dart';


class CoolRoute extends PageRouteBuilder<void> {
  CoolRoute(
    this.widget,
  ) : super(
          // 设置过度时间
          transitionDuration: const Duration(milliseconds: 4000),
          // 构造器
          pageBuilder: (
            // 上下文和动画
            BuildContext context,
            Animation<double> animation,
            Animation<double> _,
          ) {
            return widget;
          },
          opaque: false,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> _,
            Widget child,
          ) {
            return child;
          },
        );
  final Widget widget;
}
