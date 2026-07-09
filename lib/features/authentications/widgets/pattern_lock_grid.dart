import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A reusable 3x3 pattern-lock drawing surface. It only reports the drawn
/// node sequence via [onComplete] — callers decide what "setup" vs "verify"
/// means and drive [PatternLockGridState.reset]/[PatternLockGridState.shakeError]
/// accordingly.
class PatternLockGrid extends StatefulWidget {
  final ValueChanged<List<int>> onComplete;
  final Color accentColor;
  final Color errorColor;
  final int minNodes;

  const PatternLockGrid({
    super.key,
    required this.onComplete,
    this.accentColor = const Color(0xFF2D5BE3),
    this.errorColor = const Color(0xFFE0453C),
    this.minNodes = 4,
  });

  @override
  State<PatternLockGrid> createState() => PatternLockGridState();
}

class PatternLockGridState extends State<PatternLockGrid>
    with SingleTickerProviderStateMixin {
  static const int _gridSize = 3;
  static const double _hitRadius = 30;

  final List<int> _touchedNodes = [];
  Offset? _livePosition;
  bool _isError = false;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  void reset() {
    if (!mounted) return;
    setState(() {
      _touchedNodes.clear();
      _livePosition = null;
      _isError = false;
    });
  }

  void shakeError() {
    setState(() => _isError = true);
    _shakeController.forward(from: 0).whenComplete(reset);
  }

  List<Offset> _nodeCenters(Size size) {
    final cellW = size.width / _gridSize;
    final cellH = size.height / _gridSize;
    return List.generate(_gridSize * _gridSize, (i) {
      final row = i ~/ _gridSize;
      final col = i % _gridSize;
      return Offset((col + 0.5) * cellW, (row + 0.5) * cellH);
    });
  }

  int? _hitTest(Offset position, List<Offset> centers) {
    for (var i = 0; i < centers.length; i++) {
      if (!_touchedNodes.contains(i) &&
          (centers[i] - position).distance <= _hitRadius) {
        return i;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails details, List<Offset> centers) {
    final hit = _hitTest(details.localPosition, centers);
    if (hit == null) return;
    setState(() {
      _touchedNodes
        ..clear()
        ..add(hit);
      _livePosition = details.localPosition;
      _isError = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details, List<Offset> centers) {
    if (_touchedNodes.isEmpty) return;
    final hit = _hitTest(details.localPosition, centers);
    setState(() {
      _livePosition = details.localPosition;
      if (hit != null) _touchedNodes.add(hit);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_touchedNodes.length < widget.minNodes) {
      reset();
      return;
    }
    widget.onComplete(List.unmodifiable(_touchedNodes));
    setState(() => _livePosition = null);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final centers = _nodeCenters(size);
          return AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final progress = _shakeController.value;
              final shake = _isError
                  ? math.sin(progress * math.pi * 6) * 8 * (1 - progress)
                  : 0.0;
              return Transform.translate(offset: Offset(shake, 0), child: child);
            },
            child: GestureDetector(
              onPanStart: (d) => _onPanStart(d, centers),
              onPanUpdate: (d) => _onPanUpdate(d, centers),
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: size,
                painter: _PatternPainter(
                  centers: centers,
                  touchedNodes: _touchedNodes,
                  livePosition: _livePosition,
                  accentColor: widget.accentColor,
                  errorColor: widget.errorColor,
                  isError: _isError,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final List<Offset> centers;
  final List<int> touchedNodes;
  final Offset? livePosition;
  final Color accentColor;
  final Color errorColor;
  final bool isError;

  _PatternPainter({
    required this.centers,
    required this.touchedNodes,
    required this.livePosition,
    required this.accentColor,
    required this.errorColor,
    required this.isError,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeColor = isError ? errorColor : accentColor;

    final linePaint = Paint()
      ..color = activeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < touchedNodes.length - 1; i++) {
      canvas.drawLine(centers[touchedNodes[i]], centers[touchedNodes[i + 1]], linePaint);
    }
    if (touchedNodes.isNotEmpty && livePosition != null) {
      canvas.drawLine(centers[touchedNodes.last], livePosition!, linePaint);
    }

    final dotRadius = size.shortestSide / 18;
    final ringRadius = dotRadius * 2.2;
    for (var i = 0; i < centers.length; i++) {
      final touched = touchedNodes.contains(i);
      final ringPaint = Paint()
        ..color = touched ? activeColor : const Color(0xFFD8DCE6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(centers[i], ringRadius, ringPaint);

      if (touched) {
        canvas.drawCircle(centers[i], dotRadius, Paint()..color = activeColor);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) => true;
}
