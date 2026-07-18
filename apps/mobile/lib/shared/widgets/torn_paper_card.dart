import 'package:flutter/material.dart';

import '../../design_system/app_colors.dart';

class TornPaperCard extends StatelessWidget {
  const TornPaperCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 26, 24, 32),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _TornTopClipper(),
      child: ColoredBox(
        color: AppColors.paper,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _TornTopClipper extends CustomClipper<Path> {
  const _TornTopClipper();

  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, 9);
    const tooth = 12.0;
    var x = 0.0;
    while (x < size.width) {
      path.quadraticBezierTo(x + tooth / 2, 0, x + tooth, 9);
      x += tooth;
    }
    return path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_TornTopClipper oldClipper) => false;
}
