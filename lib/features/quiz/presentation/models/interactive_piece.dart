import 'package:flutter/material.dart';
import '../widgets/fraction_shape.dart';

class InteractivePiece {
  final String id;
  final ShapeType type;
  final Color color;
  Offset position;
  Offset initialPosition;
  int fractionSize;

  // Circle properties
  double? radius;
  int? index;
  int? totalPieces;

  // Rectangle properties
  double? width;
  double? height;

  InteractivePiece({
    required this.id,
    required this.type,
    required this.color,
    required this.position,
    required this.initialPosition,
    required this.fractionSize,
    this.radius,
    this.index,
    this.totalPieces,
    this.width,
    this.height,
  });
}
