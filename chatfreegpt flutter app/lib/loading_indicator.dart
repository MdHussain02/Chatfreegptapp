import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final AnimationController animationController;

  const LoadingIndicator({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Dot(animationController: animationController, index: 0),
            Dot(animationController: animationController, index: 1),
            Dot(animationController: animationController, index: 2),
          ],
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  final AnimationController animationController;
  final int index;

  const Dot({Key? key, required this.animationController, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        width: 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
