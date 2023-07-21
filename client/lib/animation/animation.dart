import 'package:flutter/material.dart';
import 'dart:math' as math;

class AwesomePageRoute extends PageRouteBuilder {
  AwesomePageRoute({
    RouteSettings? settings,
    Duration transitionDuration = const Duration(milliseconds: 300),
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
    String? barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
    Widget? enterPage,
    Widget? exitPage,
    Transition? transition,
  }) : super(
          settings: settings,
          pageBuilder: _getPageBuilder(enterPage!),
          transitionsBuilder:
              _getTransitionBuilder(enterPage, exitPage!, transition!),
          transitionDuration: transitionDuration,
          opaque: opaque,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  static RoutePageBuilder _getPageBuilder(Widget child) {
    return (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        child;
  }

  static RouteTransitionsBuilder _getTransitionBuilder(
      Widget enterPage, Widget exitPage, Transition transition) {
    return (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) =>
        transition.build(context, enterPage, exitPage, animation);
  }
}

abstract class Transition {
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation);
}

class CubeTransition extends Transition {
  final Curve curve;
  final double perspectiveScale;
  final double angle;
  final AlignmentGeometry enterPageAlignment;
  final AlignmentGeometry exitPageAlignment;
  final Color backgroundColor;

  CubeTransition({
    this.curve = Curves.easeOutSine,
    this.perspectiveScale = 0.001,
    double angle = 90,
    this.enterPageAlignment = Alignment.centerLeft,
    this.exitPageAlignment = Alignment.centerRight,
    this.backgroundColor = Colors.black,
  }) : this.angle = math.pi / 180 * angle;

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        Transform(
          alignment: exitPageAlignment,
          transform: Matrix4.identity()
            ..setEntry(3, 2, perspectiveScale)
            ..rotateY(angle * (animation.value))
            ..leftTranslate(
              -width * (animation.value),
            ),
          child: exitPage,
        ),
        Transform(
          alignment: enterPageAlignment,
          transform: Matrix4.identity()
            ..setEntry(3, 2, perspectiveScale)
            ..rotateY(-angle * (1 - animation.value))
            ..leftTranslate(
              width * (1 - animation.value),
            ),
          child: enterPage,
        ),
      ],
    );
  }
}

class AccordionTransition extends Transition {
  final Curve curve;
  final AxisDirection direction;
  final AlignmentGeometry _enterPageAlignment;
  final AlignmentGeometry _exitPageAlignment;

  AccordionTransition({
    this.curve = Curves.easeOutSine,
    this.direction = AxisDirection.left,
    AlignmentGeometry? enterPageAlignment,
    AlignmentGeometry? exitPageAlignment,
  })  : this._enterPageAlignment =
            _getEnterPageAlignment(direction, enterPageAlignment!),
        this._exitPageAlignment =
            _getExitPageAlignment(direction, exitPageAlignment!);

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    return Stack(
      children: [
        Transform(
          alignment: _exitPageAlignment,
          transform: (direction == AxisDirection.left ||
                  direction == AxisDirection.right)
              ? (Matrix4.identity()..scale(1.0 - animation.value, 1.0))
              : (Matrix4.identity()..scale(1.0, 1.0 - animation.value)),
          child: exitPage,
        ),
        Transform(
          alignment: _enterPageAlignment,
          transform: (direction == AxisDirection.left ||
                  direction == AxisDirection.right)
              ? (Matrix4.identity()..scale(animation.value, 1.0))
              : (Matrix4.identity()..scale(1.0, animation.value)),
          child: enterPage,
        ),
      ],
    );
  }

  static AlignmentGeometry _getEnterPageAlignment(
      AxisDirection direction, AlignmentGeometry alignmentGeometry) {
    // if (alignmentGeometry != null) return alignmentGeometry;
    switch (direction) {
      case AxisDirection.up:
        return Alignment.bottomCenter;
      case AxisDirection.right:
        return Alignment.centerLeft;
      case AxisDirection.down:
        return Alignment.topCenter;
      case AxisDirection.left:
      default:
        return Alignment.centerRight;
    }
  }

  static AlignmentGeometry _getExitPageAlignment(
      AxisDirection direction, AlignmentGeometry alignmentGeometry) {
    // if (alignmentGeometry != null) return alignmentGeometry;
    switch (direction) {
      case AxisDirection.up:
        return Alignment.topCenter;
      case AxisDirection.right:
        return Alignment.centerRight;
      case AxisDirection.down:
        return Alignment.bottomCenter;
      case AxisDirection.left:
      default:
        return Alignment.centerLeft;
    }
  }
}

//NICE
class ZoomOutSlideTransition extends Transition {
  final Curve curve;
  final AlignmentGeometry enterPageAlignment;
  final AlignmentGeometry exitPageAlignment;
  final double scale;
  final Color backgroundColor;

  ZoomOutSlideTransition({
    this.curve = Curves.easeOutSine,
    this.enterPageAlignment = Alignment.center,
    this.exitPageAlignment = Alignment.center,
    this.scale = 0.8,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    double scaleEnter =
        animation.value > scale ? scale + (animation.value - scale) : scale;
    double scaleExit = (1 - animation.value) > scale
        ? scale + (1 - animation.value - scale)
        : scale;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        Transform(
          alignment: exitPageAlignment,
          transform: Matrix4.identity()
            ..scale(scaleExit)
            ..leftTranslate(-width * animation.value),
          child: exitPage,
        ),
        Transform(
          alignment: enterPageAlignment,
          transform: Matrix4.identity()
            ..scale(scaleEnter)
            ..leftTranslate(width * (1 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class RotateUpTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double angle;

  RotateUpTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    double angle = 45,
  }) : this.angle = math.pi / 180 * angle;

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: backgroundColor),
        Transform(
          alignment: Alignment.topRight,
          transform: Matrix4.identity()
            ..rotateZ(-angle * animation.value)
            ..leftTranslate(width * animation.value),
          child: exitPage,
        ),
        Transform(
          alignment: Alignment.topLeft,
          transform: Matrix4.identity()
            ..rotateZ(angle * (1.0 - animation.value))
            ..leftTranslate(-width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class RotateDownTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double angle;

  RotateDownTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    double angle = 45,
  }) : this.angle = math.pi / 180 * angle;

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: backgroundColor),
        Transform(
          alignment: Alignment.bottomRight,
          transform: Matrix4.identity()
            ..rotateZ(angle * animation.value)
            ..leftTranslate(width * animation.value),
          child: exitPage,
        ),
        Transform(
          alignment: Alignment.bottomLeft,
          transform: Matrix4.identity()
            ..rotateZ(-angle * (1.0 - animation.value))
            ..leftTranslate(-width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

//NICE
class TabletTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double angle;

  TabletTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    double angle = 45,
  }) : this.angle = math.pi / 180 * angle;

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(angle * animation.value)
            ..leftTranslate(width * animation.value),
          child: exitPage,
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(-angle * (1.0 - animation.value))
            ..leftTranslate(-width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class StackTransition extends Transition {
  final Curve curve;

  StackTransition({
    this.curve = Curves.easeOutSine,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    double width = MediaQuery.of(context).size.width;
    return Transform(
      transform: Matrix4.identity()..translate(width * (1.0 - animation.value)),
      child: enterPage,
    );
  }
}

class ParallaxTransition extends Transition {
  final Curve curve;
  final double offset;

  ParallaxTransition({
    this.curve = Curves.easeOutSine,
    this.offset = 0.2,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Transform(
          transform: Matrix4.identity()..translate(-width * animation.value),
          child: exitPage,
        ),
        ClipRect(
          clipper: ParallaxClipper(value: animation.value),
          child: Transform(
            transform: Matrix4.identity()
              ..translate(width * offset * (1.0 - animation.value)),
            child: enterPage,
          ),
        ),
      ],
    );
  }
}

class ParallaxClipper extends CustomClipper<Rect> {
  final double? value;

  ParallaxClipper({this.value});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width * (1 - value!), 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class ForegroundToBackgroundTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double scale;

  ForegroundToBackgroundTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    this.scale = 0.5,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: backgroundColor),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(1.0 - (1.0 - scale) * animation.value)
            ..leftTranslate(-width * animation.value),
          child: exitPage,
        ),
        Transform(
          transform: Matrix4.identity()
            ..translate(width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class BackgroundToForegroundTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double scale;

  BackgroundToForegroundTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    this.scale = 0.5,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: backgroundColor),
        Transform(
          transform: Matrix4.identity()..translate(-width * animation.value),
          child: exitPage,
        ),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(1.0 - (1.0 - scale) * (1.0 - animation.value))
            ..leftTranslate(width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class FlipVerticalTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final AlignmentGeometry enterPageAlignment;
  final AlignmentGeometry exitPageAlignment;
  final bool reverse;

  FlipVerticalTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    this.enterPageAlignment = Alignment.center,
    this.exitPageAlignment = Alignment.center,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        animation.value > 0.5
            ? Container()
            : Transform(
                alignment: exitPageAlignment,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(math.pi * animation.value * (reverse ? -1 : 1)),
                child: exitPage,
              ),
        animation.value > 0.5
            ? Transform(
                alignment: enterPageAlignment,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateX(
                      -math.pi * (1 - animation.value) * (reverse ? -1 : 1)),
                child: enterPage,
              )
            : Container(),
      ],
    );
  }
}

class FlipHorizontalTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final AlignmentGeometry enterPageAlignment;
  final AlignmentGeometry exitPageAlignment;
  final bool reverse;
  final double perspectiveScale;

  FlipHorizontalTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    this.enterPageAlignment = Alignment.center,
    this.exitPageAlignment = Alignment.center,
    this.reverse = false,
    this.perspectiveScale = 0.002,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    return Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        animation.value > 0.5
            ? Container()
            : Transform(
                alignment: exitPageAlignment,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, perspectiveScale)
                  ..rotateY(math.pi * animation.value * (reverse ? -1 : 1)),
                child: exitPage,
              ),
        animation.value > 0.5
            ? Transform(
                alignment: enterPageAlignment,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, perspectiveScale)
                  ..rotateY(
                      -math.pi * (1 - animation.value) * (reverse ? -1 : 1)),
                child: enterPage,
              )
            : Container(),
      ],
    );
  }
}

class DepthTransition extends Transition {
  final Curve curve;
  final Color backgroundColor;
  final double scale;

  DepthTransition({
    this.curve = Curves.easeOutSine,
    this.backgroundColor = Colors.black,
    this.scale = 0.5,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: backgroundColor),
        Opacity(
          opacity: 1 - animation.value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(1.0 - (1.0 - scale) * animation.value),
            child: exitPage,
          ),
        ),
        Transform(
          transform: Matrix4.identity()
            ..translate(width * (1.0 - animation.value)),
          child: enterPage,
        ),
      ],
    );
  }
}

class DefaultTransition extends Transition {
  final Curve curve;
  final AxisDirection direction;

  DefaultTransition({
    this.curve = Curves.easeOutSine,
    this.direction = AxisDirection.left,
  });

  @override
  Widget build(BuildContext context, Widget enterPage, Widget exitPage,
      Animation<double> animation) {
    animation = CurvedAnimation(parent: animation, curve: curve);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Transform(
          transform: Matrix4.identity()
            ..translate(
                direction == AxisDirection.left
                    ? -width * animation.value
                    : direction == AxisDirection.right
                        ? width * animation.value
                        : 0.0,
                direction == AxisDirection.up
                    ? -height * animation.value
                    : direction == AxisDirection.down
                        ? height * animation.value
                        : 0.0),
          child: exitPage,
        ),
        Transform(
          transform: Matrix4.identity()
            ..translate(
                direction == AxisDirection.left
                    ? width * (1.0 - animation.value)
                    : direction == AxisDirection.right
                        ? -width * (1.0 - animation.value)
                        : 0.0,
                direction == AxisDirection.up
                    ? height * (1.0 - animation.value)
                    : direction == AxisDirection.down
                        ? -height * (1.0 - animation.value)
                        : 0.0),
          child: enterPage,
        ),
      ],
    );
  }
}
