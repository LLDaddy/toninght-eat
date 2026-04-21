import 'package:flutter/material.dart';

import '../app_tokens.dart';

class RitualPanel extends StatelessWidget {
  const RitualPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.innerPadding = const EdgeInsets.all(10),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry innerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xC822150F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xBB8A6031), width: 1.1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7A000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x45F3A530),
            blurRadius: 14,
            spreadRadius: -5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: innerPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x66E9C67E), width: 0.8),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0x20F3A530),
              Color(0x05000000),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
