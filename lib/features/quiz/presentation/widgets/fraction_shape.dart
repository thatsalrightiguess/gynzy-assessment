import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/interactive_piece.dart';
import 'division_selector.dart';

enum ShapeType { circle, rectangle }

class FractionShape extends StatefulWidget {
  final ShapeType type;
  final double size;
  final Color? color;
  final int totalPieces;
  final int rows;
  final int columns;
  final void Function(List<InteractivePiece>)? onPiecesGenerated;

  const FractionShape({
    super.key,
    required this.type,
    this.size = 200.0,
    this.color,
    this.totalPieces = 1,
    this.rows = 1,
    this.columns = 1,
    this.onPiecesGenerated,
  });

  @override
  State<FractionShape> createState() => _FractionShapeState();
}

class _FractionShapeState extends State<FractionShape> with WidgetsBindingObserver {
  Offset? _lastPosition;
  Size? _lastSize;
  late int _totalPieces;
  late int _rows;
  late int _columns;
  final GlobalKey _shapeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _totalPieces = widget.totalPieces;
    _rows = widget.rows;
    _columns = widget.columns;
    WidgetsBinding.instance.addObserver(this);
    if (widget.onPiecesGenerated != null) {
      _scheduleCheck();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FractionShape oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPiecesGenerated != null) {
      _scheduleCheck();
    }
  }

  @override
  void didChangeMetrics() {
    if (widget.onPiecesGenerated != null) {
      _scheduleCheck();
    }
  }

  void _scheduleCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPositionAndGenerate();
    });
  }

  void _checkPositionAndGenerate() {
    if (!mounted) return;
    final RenderBox? box = _shapeKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    if (_lastPosition != position || _lastSize != size) {
      _lastPosition = position;
      _lastSize = size;
      _generatePieces();
    }
  }

  void _generatePieces() {
    final RenderBox? box = _shapeKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final List<InteractivePiece> pieces = [];
    final shapeColor = widget.color ?? AppColors.primary;

    if (widget.type == ShapeType.rectangle) {
      final double pieceWidth = size.width / _columns;
      final double pieceHeight = size.height / _rows;
      final int fractionSize = _rows * _columns;

      for (int r = 0; r < _rows; r++) {
        for (int c = 0; c < _columns; c++) {
          final piecePos = Offset(position.dx + c * pieceWidth, position.dy + r * pieceHeight);
          pieces.add(InteractivePiece(
            id: '${widget.type.name}_${_rows}_${_columns}_${r}_$c',
            type: ShapeType.rectangle,
            color: shapeColor,
            position: piecePos,
            initialPosition: piecePos,
            fractionSize: fractionSize,
            width: pieceWidth,
            height: pieceHeight,
          ));
        }
      }
    } else {
      final double radius = size.width / 2;
      for (int i = 0; i < _totalPieces; i++) {
        pieces.add(InteractivePiece(
          id: '${widget.type.name}_${_totalPieces}_$i',
          type: ShapeType.circle,
          color: shapeColor,
          position: position,
          initialPosition: position,
          fractionSize: _totalPieces,
          radius: radius,
          index: i,
          totalPieces: _totalPieces,
        ));
      }
    }

    widget.onPiecesGenerated!(pieces);
  }

  void _onDivisionsChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _generatePieces();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRectangle = widget.type == ShapeType.rectangle;
    final width = isRectangle ? widget.size * 1.5 : widget.size;
    final height = widget.size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          key: _shapeKey,
          width: width,
          height: height,
        ),
        const SizedBox(height: 16),
        if (isRectangle)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DivisionSelector(
                label: 'Rows',
                value: _rows,
                onDecrement: _rows > 1 ? () {
                  setState(() => _rows--);
                  _onDivisionsChanged();
                } : null,
                onIncrement: () {
                  setState(() => _rows++);
                  _onDivisionsChanged();
                },
              ),
              const SizedBox(width: 16),
              DivisionSelector(
                label: 'Columns',
                value: _columns,
                onDecrement: _columns > 1 ? () {
                  setState(() => _columns--);
                  _onDivisionsChanged();
                } : null,
                onIncrement: () {
                  setState(() => _columns++);
                  _onDivisionsChanged();
                },
              ),
            ],
          )
        else
          DivisionSelector(
            label: 'Pieces',
            value: _totalPieces,
            onDecrement: _totalPieces > 1 ? () {
              setState(() => _totalPieces--);
              _onDivisionsChanged();
            } : null,
            onIncrement: () {
              setState(() => _totalPieces++);
              _onDivisionsChanged();
            },
          ),
      ],
    );
  }
}
