# Flutter Rotated View 

A widget which can be rotated and can have virtual inertia and drag or a sensor that controls its rotation

## Installation

Add `rotated_view` as a dependency in your pubspec.yaml file ([how?](https://flutter.io/using-packages/)).

Import Rotated View:
```dart
import 'package:rotated_view/rotated_view.dart';
```
## Full screen usage

Given a `ImageProvider imageProvider` (such as [AssetImage](https://docs.flutter.io/flutter/painting/AssetImage-class.html) or [NetworkImage](https://docs.flutter.io/flutter/painting/NetworkImage-class.html)):

```dart
@override
Widget build(BuildContext context) {
  return Container(
    child: RotatedView(
      child: AssetImage("assets/Nightmare_MYS.png"),
    )
  );
}
```