import 'package:flutter/material.dart';
import 'fraction_shape.dart';
import '../models/interactive_piece.dart';

class QuestionViewPanel extends StatelessWidget {
  final void Function(List<InteractivePiece>)? onPiecesGenerated;
  final ShapeType shapeType;

  const QuestionViewPanel({
    super.key, 
    this.onPiecesGenerated,
    this.shapeType = ShapeType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionShape(
            key: ValueKey(shapeType),
            type: shapeType, 
            totalPieces: shapeType == ShapeType.circle ? 8 : 1,
            rows: shapeType == ShapeType.rectangle ? 2 : 1,
            columns: shapeType == ShapeType.rectangle ? 3 : 1,
            onPiecesGenerated: onPiecesGenerated,
          ),
        ],
      ),
    );
  }
}
