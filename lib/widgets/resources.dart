import 'package:flutter/material.dart';

List<String> meses = [
  "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
];

List<String> mesesLetras = [
  "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sept", "Oct", "Nov", "Dic"
];


class MyPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = const Offset(0, 0);
    final p2 = Offset((size.width / 2) - 15, 0);
    final paint = Paint()
      ..color = const Color(0xffA0A0A0)
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);

    final p3 = Offset(size.width / 2, 10);
    canvas.drawLine(p2, p3, paint);

    final p4 = Offset((size.width / 2) + 15, 0);
    canvas.drawLine(p3, p4, paint);

    final p5 = Offset(size.width, 0);
    canvas.drawLine(p4, p5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class MyPainter2 extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = const Offset(0, 0);
    final p2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = const Color(0xffA0A0A0)
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
