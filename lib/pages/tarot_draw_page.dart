import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../models/menu_generation_result.dart';
import '../models/user_profile.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/metal_action_button.dart';
import '../ui/components/ritual_panel.dart';
import '../ui/components/ritual_tarot_ring.dart';

class TarotDrawResult {
  const TarotDrawResult({
    required this.menuResult,
    required this.refreshNonce,
  });

  final MenuGenerationResult menuResult;
  final int refreshNonce;
}

class TarotDrawPage extends StatefulWidget {
  const TarotDrawPage({
    super.key,
    required this.profile,
    required this.baseRefreshNonce,
    required this.generateMenu,
  });

  final UserProfile profile;
  final int baseRefreshNonce;
  final Future<MenuGenerationResult> Function(int refreshNonce) generateMenu;

  @override
  State<TarotDrawPage> createState() => _TarotDrawPageState();
}

enum _DrawPhase { idle, drawing, result }

class _TarotDrawPageState extends State<TarotDrawPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _ringScale;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _resultOpacity;

  _DrawPhase _phase = _DrawPhase.idle;
  MenuGenerationResult? _result;
  int _drawCount = 0;
  int _latestRefreshNonce = 0;

  bool get _isDrawing => _phase == _DrawPhase.drawing;

  @override
  void initState() {
    super.initState();
    // 3段轻量动画：卡阵呼吸 -> 光晕增强 -> 结果淡入，总时长约 1.4s。
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ringScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.96, end: 1.03)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.03, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
    ]).animate(_controller);
    _glowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.82, curve: Curves.easeInOut),
    );
    _resultOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.62, 1, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startDraw() async {
    if (_isDrawing) return;
    final refreshNonce = widget.baseRefreshNonce + _drawCount + 1;
    _drawCount += 1;

    setState(() => _phase = _DrawPhase.drawing);
    try {
      MenuGenerationResult? generated;
      await Future.wait<void>([
        _controller.forward(from: 0).orCancel,
        widget.generateMenu(refreshNonce).then((value) => generated = value),
      ]);
      if (!mounted || generated == null) return;
      setState(() {
        _latestRefreshNonce = refreshNonce;
        _result = generated;
        _phase = _DrawPhase.result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _phase = _DrawPhase.idle);
      _showSnack(context.l10n.tarotDrawFailed(e.toString()));
    }
  }

  void _confirmMenu() {
    final result = _result;
    if (result == null) return;
    Navigator.of(context).pop(
      TarotDrawResult(
        menuResult: result,
        refreshNonce: _latestRefreshNonce,
      ),
    );
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _normalizeRecipeName(String name) {
    var fixed = name;
    if (fixed.contains('粉丝虾') && (fixed.contains('囗') || fixed.contains('□'))) {
      fixed = '蒜蓉粉丝虾';
    }
    if (fixed.startsWith('三鲜菌菇') &&
        (fixed.endsWith('囗') || fixed.endsWith('□'))) {
      fixed = '三鲜菌菇煲';
    }
    return fixed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.tarotTitle,
      showAppBar: false,
      showBackgroundGlow: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/kitchen_scene_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withValues(alpha: 0.56),
                    Colors.black.withValues(alpha: 0.24),
                    Colors.black.withValues(alpha: 0.46),
                  ],
                  stops: const <double>[0, 0.45, 1],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 0.95,
                    colors: <Color>[
                      Color(0x40FFAF53),
                      Color(0x16FF8A2E),
                      Colors.transparent,
                    ],
                    stops: <double>[0, 0.52, 1],
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      Color(0x78D55A16),
                      Color(0x1FD56A1E),
                      Colors.transparent,
                    ],
                    stops: <double>[0, 0.3, 0.58],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  _buildPageTitle(),
                  const SizedBox(height: 6),
                  _buildPhaseBadge(),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 6,
                    child: Center(child: _buildTarotArea()),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 174,
                    child: _buildResultArea(),
                  ),
                  const SizedBox(height: 12),
                  _buildActionArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Align(
              alignment: Alignment(-1, 0),
              child: _DrawTitleWing(),
            ),
            const Align(
              alignment: Alignment(1, 0),
              child: _DrawTitleWing(reverse: true),
            ),
            Text(
              context.l10n.tarotTitle,
              maxLines: 1,
              softWrap: false,
              style: const TextStyle(
                color: Color(0xFFF8D184),
                fontSize: 48,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    color: Color(0xC021130A),
                    blurRadius: 9,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseBadge() {
    final (label, color) = switch (_phase) {
      _DrawPhase.idle => (context.l10n.tarotPhaseIdle, const Color(0xFFD8B77B)),
      _DrawPhase.drawing => (
          context.l10n.tarotPhaseDrawing,
          const Color(0xFFFFD88A)
        ),
      _DrawPhase.result => (
          context.l10n.tarotPhaseResult,
          const Color(0xFFFFD88A)
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x7725150D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xAA7A532A), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _phase == _DrawPhase.result
                ? Icons.auto_awesome
                : Icons.local_fire_department,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarotArea() {
    final wiggle =
        _isDrawing ? math.sin(_controller.value * math.pi * 4) * 0.035 : 0.0;
    final ringScale = _isDrawing ? _ringScale.value : 1.0;
    final glow = _isDrawing ? _glowOpacity.value : 0.0;

    return RitualTarotRing(
      wiggle: wiggle,
      scale: ringScale,
      glowOpacity: glow * 0.72,
    );
  }

  Widget _buildResultArea() {
    if (_phase == _DrawPhase.idle) {
      return RitualPanel(
        child: Center(
          child: Text(
            context.l10n.tarotReadyHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTextSize.md,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    if (_phase == _DrawPhase.drawing) {
      return RitualPanel(
        child: Center(
          child: Text(
            context.l10n.tarotDrawingHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTextSize.md,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final result = _result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _resultOpacity,
      child: RitualPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 14, color: Color(0xFFE9C67E)),
                SizedBox(width: 6),
                Text(
                  context.l10n.tarotResultTitle,
                  style: TextStyle(
                    fontSize: AppTextSize.lg,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...result.selectedItems.map((item) {
              final displayName = _normalizeRecipeName(item.recipe.name);
              final typeLabel = item.recipe.isSoup
                  ? context.l10n.commonSoup
                  : context.l10n.commonDish;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  context.l10n.tarotResultLine(
                    displayName,
                    typeLabel,
                    item.recipe.cookMinutes,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    if (_phase == _DrawPhase.result && _result != null) {
      return Row(
        children: [
          Flexible(
            flex: 4,
            child: _RitualSecondaryButton(
              label: context.l10n.tarotRedraw,
              onPressed: _startDraw,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            flex: 8,
            child: MetalActionButton(
              label: context.l10n.tarotUseThisMenu,
              onPressed: _confirmMenu,
              fontSize: 20,
              horizontalPadding: 16,
            ),
          ),
        ],
      );
    }

    return MetalActionButton(
      label: _isDrawing
          ? context.l10n.tarotDrawingButton
          : context.l10n.tarotDrawTodayMenuButton,
      onPressed: _isDrawing ? null : _startDraw,
    );
  }
}

class _RitualSecondaryButton extends StatelessWidget {
  const _RitualSecondaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: Color(0xAAE2B56D), width: 1.2),
        backgroundColor: const Color(0x7A2A1B12),
        foregroundColor: const Color(0xFFF2D198),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DrawTitleWing extends StatelessWidget {
  const _DrawTitleWing({this.reverse = false});

  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: reverse ? -1 : 1,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0x00F4C064), Color(0xFFF4C064)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 3),
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFECC677)),
          const SizedBox(width: 3),
          Container(width: 10, height: 1.4, color: const Color(0xFFF0C267)),
        ],
      ),
    );
  }
}
