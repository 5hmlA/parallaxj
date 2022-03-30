import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Parallaxable extends StatefulWidget {
  final double angle;
  final double offsetRadio;
  final double offsetDepth;
  final double rotateDiff;
  final Widget above;
  final Widget under;
  final bool listen;

  const Parallaxable({
    Key? key,
    required this.above,
    required this.under,
    this.angle = math.pi / 9,
    this.rotateDiff = 1.1,
    this.offsetRadio = 1.0 / 6,
    this.offsetDepth = 2,
    this.listen = false,
  }) : super(key: key);

  @override
  _ParallaxableState createState() => _ParallaxableState();
}

class _ParallaxableState extends State<Parallaxable> with SingleTickerProviderStateMixin {
  late double halfWidth;
  late double halfHeight;
  double xpercent = 1;
  double ypercent = 1;
  final rotating = 0;
  bool reverse = false;
  late AnimationController _aniController;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _aniController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        if(reverse) {
          reverse = false;
          _aniController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _aniController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      halfHeight = constraints.maxHeight / 2;
      halfWidth = constraints.maxWidth / 2;
      return AnimatedBuilder(
        builder: (BuildContext context, Widget? child) {
          final double rotatex = widget.angle * _aniController.value * xpercent;
          final double rotatey = widget.angle * _aniController.value * ypercent;
          final double translatex = widget.offsetRadio == 0
              ? 0
              : _aniController.value * halfHeight * widget.offsetRadio * ypercent * -1;
          // double translatex = _aniController.value * halfHeight * widget.offsetRadio * ypercent;
          final double translatey =
              widget.offsetRadio == 0 ? 0 : _aniController.value * halfWidth * widget.offsetRadio * xpercent;
          final stack = Stack(
            children: [
              Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(rotatey)
                    ..rotateX(rotatex),
                  alignment: Alignment.center,
                  child: widget.under),
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotatey / widget.rotateDiff)
                  ..translate(translatex, translatey, widget.offsetDepth)
                  ..rotateX(rotatex / widget.rotateDiff),
                alignment: Alignment.center,
                child: widget.above,
              ),
            ],
          );
          if (widget.listen) {
           return Listener(
              onPointerMove: (event) => _panUpdate(event.localPosition.dx, event.localPosition.dy),
              onPointerCancel: (event) => _tapUp(),
              onPointerDown: (event) => _panDown(event.localPosition.dx, event.localPosition.dy),
              onPointerUp: (event) => _tapUp(),
              child: stack,
            );
          }

          return GestureDetector(
            onPanCancel: _tapUp,
            onPanEnd: (event) => _tapUp(),
            onPanUpdate: (event) => _panUpdate(event.localPosition.dx, event.localPosition.dy),
            onTapUp: (event) => _tapUp(),
            onPanDown: (event) => _panDown(event.localPosition.dx, event.localPosition.dy),
            child: stack,
          );
        },
        animation: _aniController,
      );
    });
  }

  void _panUpdate(double dx, double dy) {
    setState(() {
      ypercent = ((halfWidth - dx) / halfWidth).clamp(-1, 1);
      xpercent = ((dy - halfHeight) / halfHeight).clamp(-1, 1);
    });
  }

  void _panDown(double dx, double dy) {
    ypercent = (halfWidth - dx) / halfWidth;
    xpercent = (dy - halfHeight) / halfHeight;
    reverse = false;
    if (_aniController.isAnimating) {
      _aniController.stop();
    }
      _aniController.forward();
  }

  void _tapUp() {
    if (!_aniController.isAnimating) {
      _aniController.reverse();
    }else {
      reverse = true;
    }
  }
}
