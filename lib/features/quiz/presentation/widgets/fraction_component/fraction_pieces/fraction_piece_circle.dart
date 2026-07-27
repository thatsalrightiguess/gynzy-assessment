import 'dart:math' as math;
import 'package:flutter/material.dart';

class FractionPieceCircle extends StatefulWidget {
  final double radius;
  final int index;
  final int totalPieces;
  final Color color;
  final String? image;
  final ValueChanged<Offset>? onPanUpdate;
  final VoidCallback? onPanEnd;

  const FractionPieceCircle({
    super.key,
    required this.radius,
    required this.index,
    required this.totalPieces,
    this.color = Colors.blue,
    this.image,
    this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  State<FractionPieceCircle> createState() => _FractionPieceCircleState();
}

class _FractionPieceCircleState extends State<FractionPieceCircle> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SliceClipper(widget.index, widget.totalPieces),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (widget.onPanUpdate != null) {
              widget.onPanUpdate!(details.delta);
            }
          },
          onPanEnd: (details) {
            if (widget.onPanEnd != null) {
              widget.onPanEnd!();
            }
          },
          child: Stack(
            children: [
              Image.asset(
                'lib/assets/images/foods/pizza/${widget.image ?? 'pizza_1'}.png',
                width: widget.radius * 2,
                height: widget.radius * 2,
                fit: BoxFit.cover,
              ),
              CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _FractionPieceCirclePainter(
                  radius: widget.radius,
                  index: widget.index,
                  totalPieces: widget.totalPieces,
                  color: widget.color,
                  isHovered: isHovered,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliceClipper extends CustomClipper<Path> {
  final int index;
  final int totalPieces;

  _SliceClipper(this.index, this.totalPieces);

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final pieceAngle = 2 * math.pi / totalPieces;
    final startAngle = (index * pieceAngle) - (math.pi / 2);

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pieceAngle,
        false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _SliceClipper oldClipper) {
    return oldClipper.index != index || oldClipper.totalPieces != totalPieces;
  }
}

class _FractionPieceCirclePainter extends CustomPainter {
  final double radius;
  final int index;
  final int totalPieces;
  final Color color;
  final bool isHovered;

  _FractionPieceCirclePainter({
    required this.radius,
    required this.index,
    required this.totalPieces,
    required this.color,
    required this.isHovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final pieceAngle = 2 * math.pi / totalPieces;
    final startAngle = (index * pieceAngle) - (math.pi / 2);

    if (isHovered) {
      final fillPaint = Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, pieceAngle, true, fillPaint);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawArc(rect, startAngle, pieceAngle, true, linePaint);
  }

  @override
  bool shouldRepaint(covariant _FractionPieceCirclePainter oldDelegate) {
    return oldDelegate.index != index ||
        oldDelegate.totalPieces != totalPieces ||
        oldDelegate.color != color ||
        oldDelegate.isHovered != isHovered ||
        oldDelegate.radius != radius;
  }
}
