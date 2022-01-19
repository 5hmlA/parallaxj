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

  const Parallaxable({
    Key? key,
    required this.above,
    required this.under,
    this.angle = math.pi / 9,
    this.rotateDiff = 1.1,
    this.offsetRadio = 1.0 / 6,
    this.offsetDepth = 2,
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

  late AnimationController _aniController;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
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
          final double translatex =
              widget.offsetRadio == 0 ? 0 : _aniController.value * halfHeight * widget.offsetRadio * ypercent * -1;
          // double translatex = _aniController.value * halfHeight * widget.offsetRadio * ypercent;
          final double translatey =
              widget.offsetRadio == 0 ? 0 : _aniController.value * halfWidth * widget.offsetRadio * xpercent;
          return GestureDetector(
            onPanEnd: _panEnd,
            onPanUpdate: _panUpdate,
            onTapUp: _tapUp,
            onPanDown: _panDown,
            child: Stack(
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
            ),
          );
        },
        animation: _aniController,
      );
    });
  }

  void _panUpdate(DragUpdateDetails details) {
    setState(() {
      ypercent = ((halfWidth - details.localPosition.dx) / halfWidth).clamp(-1, 1);
      xpercent = ((details.localPosition.dy - halfHeight) / halfHeight).clamp(-1, 1);
    });
  }

  void _panDown(DragDownDetails details) {
    _aniController.forward();
    setState(() {
      ypercent = (halfWidth - details.localPosition.dx) / halfWidth;
      xpercent = (details.localPosition.dy - halfHeight) / halfHeight;
    });
  }

  void _tapUp(TapUpDetails details) {
    _aniController.reverse();
  }

  void _panEnd(DragEndDetails details) {
    _aniController.reverse();
  }
}
