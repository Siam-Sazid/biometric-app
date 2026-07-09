import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_controller.dart';
import 'pattern_lock_grid.dart';

const _accentColor = Color(0xFF2D5BE3);

/// Opens the pattern setup flow (draw, then confirm by redrawing).
/// Returns true if a pattern was saved.
Future<bool> showPatternSetupDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const PatternSetupDialog(),
  );
  return result ?? false;
}

enum _SetupStage { drawFirst, confirmRedraw }

class PatternSetupDialog extends StatefulWidget {
  const PatternSetupDialog({super.key});

  @override
  State<PatternSetupDialog> createState() => _PatternSetupDialogState();
}

class _PatternSetupDialogState extends State<PatternSetupDialog> {
  _SetupStage _stage = _SetupStage.drawFirst;
  List<int>? _firstDraw;
  String? _message;
  int _attempt = 0;

  void _onComplete(List<int> nodes) {
    if (_stage == _SetupStage.drawFirst) {
      setState(() {
        _firstDraw = nodes;
        _stage = _SetupStage.confirmRedraw;
        _message = null;
        _attempt++;
      });
      return;
    }

    if (listEquals(_firstDraw, nodes)) {
      _savePattern(nodes);
    } else {
      setState(() {
        _firstDraw = null;
        _stage = _SetupStage.drawFirst;
        _message = "Patterns didn't match. Start over.";
        _attempt++;
      });
    }
  }

  Future<void> _savePattern(List<int> nodes) async {
    await context.read<AuthController>().setPattern(nodes.join(','));
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isConfirm = _stage == _SetupStage.confirmRedraw;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isConfirm ? 'Confirm your pattern' : 'Set a backup pattern',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              _message ?? (isConfirm ? 'Draw it again to confirm' : 'Connect at least 4 dots'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _message != null ? const Color(0xFFE0453C) : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 20),
            PatternLockGrid(
              key: ValueKey(_attempt),
              onComplete: _onComplete,
              accentColor: _accentColor,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
