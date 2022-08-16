import 'package:flutter/material.dart';

class CrossFadeWidget extends StatelessWidget {
  final Widget firstChild;
  final Widget secondChild;

  final CrossFadeState crossFadeState;
  const CrossFadeWidget({Key? key, required this.firstChild, required this.secondChild, required this.crossFadeState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: crossFadeState,
      duration: const Duration(milliseconds: 200),
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              key: bottomChildKey,
              child: bottomChild,
            ),
            Positioned.fill(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}
