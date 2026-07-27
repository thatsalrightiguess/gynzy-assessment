import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../models/interactive_piece.dart';

enum ShapeType { circle, rectangle }

class FractionShape extends StatefulWidget {
  final ShapeType type;
  final double size;
  final Color? color;
  final int totalPieces;
  final void Function(List<InteractivePiece>)? onPiecesGenerated;
  final String? image;

  const FractionShape({
    super.key,
    required this.type,
    this.size = 200.0,
    this.color,
    this.totalPieces = 1,
    this.onPiecesGenerated,
    this.image,
  });

  @override
  State<FractionShape> createState() => _FractionShapeState();
}

class _FractionShapeState extends State<FractionShape> with WidgetsBindingObserver {
  Offset? _lastPosition;
  Size? _lastSize;
  final GlobalKey _shapeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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
    if (oldWidget.totalPieces != widget.totalPieces || oldWidget.type != widget.type) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _generatePieces();
      });
    } else if (widget.onPiecesGenerated != null) {
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

    final double radius = size.width / 2;
    for (int i = 0; i < widget.totalPieces; i++) {
      pieces.add(InteractivePiece(
        id: '${widget.type.name}_${widget.totalPieces}_$i',
        type: ShapeType.circle,
        color: shapeColor,
        position: position,
        initialPosition: position,
        fractionSize: widget.totalPieces,
        image: widget.image,
        radius: radius,
        index: i,
        totalPieces: widget.totalPieces,
      ));
    }

    widget.onPiecesGenerated?.call(pieces);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              key: _shapeKey,
            ),
          ),
        ),
      ),
    );
  }
}
