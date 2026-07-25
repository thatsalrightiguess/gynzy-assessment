import 'package:flutter/material.dart';
import '../widgets/fraction_shape.dart';

class FractionPieceData {
  final ShapeType type;
  final int fractionSize;
  final Color color;

  // Circle properties
  final double? radius;
  final int? index;
  final int? totalPieces;

  // Rectangle properties
  final double? width;
  final double? height;

  FractionPieceData({
    required this.type,
    required this.fractionSize,
    required this.color,
    this.radius,
    this.index,
    this.totalPieces,
    this.width,
    this.height,
  });
}
