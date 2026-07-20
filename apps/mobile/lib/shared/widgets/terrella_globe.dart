import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design_system/app_colors.dart';

class TerrellaGlobe extends StatefulWidget {
  const TerrellaGlobe({
    super.key,
    this.height = 300,
    this.progress = 0.42,
    this.compact = false,
  });

  final double height;
  final double progress;
  final bool compact;

  @override
  State<TerrellaGlobe> createState() => _TerrellaGlobeState();
}

class _TerrellaGlobeState extends State<TerrellaGlobe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour reduced motion: hold a static frame and stop the ticker entirely
    // rather than animating invisibly. Leaving it running also strands a
    // pending timer, which is invalid once the tree is disposed (e.g. tests).
    if (MediaQuery.disableAnimationsOf(context)) {
      if (_controller.isAnimating) _controller.stop();
      _controller.value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _TerrellaGlobePainter(
              phase: reduceMotion ? 0.25 : _controller.value,
              routeProgress: widget.progress,
              compact: widget.compact,
            ),
          ),
        ),
      ),
    );
  }
}

class _TerrellaGlobePainter extends CustomPainter {
  _TerrellaGlobePainter({
    required this.phase,
    required this.routeProgress,
    required this.compact,
  });

  final double phase;
  final double routeProgress;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      background,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -1.15),
          radius: 1.15,
          colors: [Color(0xFF111D40), AppColors.surfaceRaised],
        ).createShader(background),
    );
    _drawStars(canvas, size);

    final radius = compact
        ? math.min(size.width * 0.64, size.height * 1.08)
        : math.min(size.width * 0.43, size.height * 0.47);
    final center = Offset(
      size.width * (compact ? 0.58 : 0.50),
      size.height * (compact ? 0.70 : 0.48),
    );
    final sphere = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius + 12,
      Paint()
        ..color = AppColors.cyan.withValues(alpha: 0.055)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.38, -0.45),
          radius: 1.02,
          colors: [Color(0xFF182956), Color(0xFF080D1C)],
          stops: [0, 1],
        ).createShader(sphere),
    );

    canvas.save();
    canvas.clipPath(Path()..addOval(sphere));
    _drawGrid(canvas, center, radius);
    _drawContinents(canvas, center, radius);
    _drawRoutes(canvas, center, radius);
    canvas.restore();

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.cyan.withValues(alpha: 0.28),
    );
  }

  void _drawStars(Canvas canvas, Size size) {
    final starPaint = Paint()..color = const Color(0xFFA9BCEC);
    for (var i = 0; i < 58; i++) {
      final x = ((i * 83) % 97) / 97 * size.width;
      final y = ((i * 47 + 13) % 89) / 89 * size.height;
      final pulse =
          0.22 +
          0.42 * (0.5 + 0.5 * math.sin((phase * math.pi * 2) + (i * 0.73)));
      starPaint.color = const Color(0xFFA9BCEC).withValues(alpha: pulse);
      final dot = i % 9 == 0 ? 1.35 : 0.75;
      canvas.drawCircle(Offset(x, y), dot, starPaint);
    }
  }

  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final grid = Paint()
      ..color = AppColors.cyan.withValues(alpha: 0.075)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (final scale in [0.32, 0.62]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: radius * 2 * scale,
        ),
        grid,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2 * scale,
          height: radius * 2,
        ),
        grid,
      );
    }
  }

  void _drawContinents(Canvas canvas, Offset c, double r) {
    final coast = Paint()
      ..color = const Color(0xFF637DB5).withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    final edge = Paint()
      ..color = const Color(0xFFA9BCEC).withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    Path land(List<Offset> points) {
      final path = Path();
      path.moveTo(c.dx + points.first.dx * r, c.dy + points.first.dy * r);
      for (final point in points.skip(1)) {
        path.lineTo(c.dx + point.dx * r, c.dy + point.dy * r);
      }
      return path..close();
    }

    final northAmerica = land(const [
      Offset(-0.88, -0.42),
      Offset(-0.66, -0.72),
      Offset(-0.30, -0.78),
      Offset(-0.06, -0.55),
      Offset(-0.18, -0.33),
      Offset(-0.05, -0.16),
      Offset(-0.27, 0.03),
      Offset(-0.40, 0.25),
      Offset(-0.56, 0.17),
      Offset(-0.63, -0.08),
      Offset(-0.84, -0.18),
    ]);
    final southAmerica = land(const [
      Offset(-0.32, 0.20),
      Offset(-0.03, 0.28),
      Offset(0.08, 0.47),
      Offset(-0.12, 0.88),
      Offset(-0.30, 0.62),
      Offset(-0.40, 0.33),
    ]);
    final europeAfrica = land(const [
      Offset(0.13, -0.46),
      Offset(0.55, -0.58),
      Offset(0.78, -0.31),
      Offset(0.55, -0.08),
      Offset(0.50, 0.24),
      Offset(0.30, 0.72),
      Offset(0.07, 0.42),
      Offset(0.00, 0.02),
      Offset(0.16, -0.16),
    ]);
    for (final path in [northAmerica, southAmerica, europeAfrica]) {
      canvas.drawPath(path, coast);
      canvas.drawPath(path, edge);
    }
  }

  void _drawRoutes(Canvas canvas, Offset c, double r) {
    final origin = Offset(c.dx - r * 0.57, c.dy + r * 0.11);
    final destination = Offset(c.dx + r * 0.43, c.dy - r * 0.31);
    final planned = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        c.dx - r * 0.02,
        c.dy - r * 0.65,
        destination.dx,
        destination.dy,
      );
    _drawDashedPath(
      canvas,
      planned,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 1.5 : 2
        ..strokeCap = StrokeCap.round
        ..color = AppColors.cyan.withValues(alpha: 0.9),
    );

    final inboundStart = Offset(c.dx - r * 0.78, c.dy - r * 0.45);
    final inbound = Path()
      ..moveTo(inboundStart.dx, inboundStart.dy)
      ..quadraticBezierTo(
        c.dx - r * 0.82,
        c.dy - r * 0.04,
        origin.dx,
        origin.dy,
      );
    canvas.drawPath(
      inbound,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = compact ? 1.8 : 2.4
        ..strokeCap = StrokeCap.round
        ..color = AppColors.amber.withValues(alpha: 0.88),
    );

    final metric = planned.computeMetrics().first;
    final movingProgress = compact
        ? (routeProgress + phase * 0.12) % 1
        : routeProgress.clamp(0.0, 1.0);
    final tangent = metric.getTangentForOffset(metric.length * movingProgress);
    if (tangent != null) {
      _drawAircraft(canvas, tangent.position, tangent.angle);
    }

    _drawAirport(canvas, origin, 'SFO', const Offset(-28, 18), true);
    _drawAirport(canvas, destination, 'JFK', const Offset(7, -7), false);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(5.0, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += 10;
      }
    }
  }

  void _drawAircraft(Canvas canvas, Offset position, double angle) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    canvas.drawCircle(
      Offset.zero,
      12,
      Paint()
        ..color = AppColors.amber.withValues(alpha: 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    final plane = Path()
      ..moveTo(9, 0)
      ..lineTo(-2, -2)
      ..lineTo(-7, -7)
      ..lineTo(-9, -6)
      ..lineTo(-6, 0)
      ..lineTo(-9, 6)
      ..lineTo(-7, 7)
      ..lineTo(-2, 2)
      ..close();
    canvas.drawPath(plane, Paint()..color = AppColors.amber);
    canvas.restore();
  }

  void _drawAirport(
    Canvas canvas,
    Offset position,
    String code,
    Offset labelOffset,
    bool hot,
  ) {
    final color = hot ? AppColors.amber : AppColors.ink;
    canvas.drawCircle(
      position,
      3.2,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    final painter = TextPainter(
      text: TextSpan(
        text: code,
        style: TextStyle(
          color: hot ? AppColors.amberLight : AppColors.inkSoft,
          fontFamily: 'SpaceMono',
          fontSize: compact ? 8 : 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, position + labelOffset);
  }

  @override
  bool shouldRepaint(_TerrellaGlobePainter oldDelegate) =>
      phase != oldDelegate.phase ||
      routeProgress != oldDelegate.routeProgress ||
      compact != oldDelegate.compact;
}
