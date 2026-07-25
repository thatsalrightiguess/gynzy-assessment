import 'package:flutter/material.dart';

class FractionPieceRectangle extends StatefulWidget {
  final Color color;
  final int fractionSize;
  final double width;
  final double height;
  final ValueChanged<Offset>? onPanUpdate;
  final VoidCallback? onPanEnd;

  const FractionPieceRectangle({
    super.key,
    required this.color,
    required this.fractionSize,
    required this.width,
    required this.height,
    this.onPanUpdate,
    this.onPanEnd,
  });

  @override
  State<FractionPieceRectangle> createState() => _FractionPieceRectangleState();
}

class _FractionPieceRectangleState extends State<FractionPieceRectangle> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isHovered ? widget.color.withOpacity(0.5) : Colors.transparent,
            border: Border.all(color: widget.color, width: 2.0),
          ),
        ),
      ),
    );
  }
}
