import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';

enum Direction { left, right }

class CirclePainter extends CustomPainter {
  final Color color;
  final Direction direction;

  CirclePainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..shader = RadialGradient(
        stops: const [0.8, 1.0],
        colors: [
          color,
          CQColors.slate100.withOpacity(0.3),
        ],
      ).createShader(
        Rect.fromCircle(center: const Offset(10, 10), radius: 7),
      );

    final Paint shadowPaint = Paint()
      ..color = CQColors.slate100.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 5);

    final Path path = Path();
    path.addOval(
      Rect.fromCircle(center: const Offset(10, 10), radius: 7),
    );

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
