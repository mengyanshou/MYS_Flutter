# Flutter Rotated View 

A widget which can be rotated and can have virtual inertia and drag or a sensor that controls its rotation

## Installation

Add `rotated_view` as a dependency in your pubspec.yaml file ([how?](https://flutter.io/using-packages/)).

Import Rotated View:
```dart
import 'package:rotated_view/rotated_view.dart';
```
## usage

Given a `child Widget` :

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

Result: 

![In action](https://github.com/renancaraujo/photo_view/blob/master/screen1.gif)

### More screenshots


| Small image | Animated GIF  | Limited scale | Hero animation |
| ------------- | ------------- | ------------- | ------------- |
| ![In action](https://github.com/renancaraujo/photo_view/blob/master/screen2.gif) | ![In action](https://github.com/renancaraujo/photo_view/blob/master/screen3.gif) | ![In action](https://github.com/renancaraujo/photo_view/blob/master/screen4.gif) | ![In action](https://github.com/renancaraujo/photo_view/blob/master/screen6.gif) |
