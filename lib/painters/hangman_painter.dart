import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  HangmanPainter(this.errors);

  final int errors;

  @override
  void paint(Canvas canvas, Size size) {
    final wood = Paint()
      ..color = const Color(0xFF654321)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final person = Paint()
      ..color = const Color(0xFFB3261E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final left = size.width * 0.28;
    const top = 14.0;
    final bottom = size.height - 12;
    canvas.drawLine(Offset(left, bottom), Offset(left + 90, bottom), wood);
    canvas.drawLine(Offset(left + 45, bottom), Offset(left + 45, top), wood);
    canvas.drawLine(Offset(left + 45, top), Offset(left + 120, top), wood);
    canvas.drawLine(
      Offset(left + 120, top),
      Offset(left + 120, top + 22),
      wood,
    );

    final head = Offset(left + 120, top + 40);
    if (errors >= 1) canvas.drawCircle(head, 18, person);
    if (errors >= 2) {
      canvas.drawLine(
        Offset(head.dx, head.dy + 18),
        Offset(head.dx, head.dy + 72),
        person,
      );
    }
    if (errors >= 3) {
      canvas.drawLine(
        Offset(head.dx, head.dy + 32),
        Offset(head.dx - 25, head.dy + 55),
        person,
      );
    }
    if (errors >= 4) {
      canvas.drawLine(
        Offset(head.dx, head.dy + 32),
        Offset(head.dx + 25, head.dy + 55),
        person,
      );
    }
    if (errors >= 5) {
      canvas.drawLine(
        Offset(head.dx, head.dy + 72),
        Offset(head.dx - 23, head.dy + 105),
        person,
      );
    }
    if (errors >= 6) {
      canvas.drawLine(
        Offset(head.dx, head.dy + 72),
        Offset(head.dx + 23, head.dy + 105),
        person,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) =>
      errors != oldDelegate.errors;
}
