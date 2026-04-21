import 'package:flutter/material.dart';

import '../app_tokens.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final button = _GradientButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      enabled: enabled,
    );
    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    required this.enabled,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? AppGradients.primaryButton
              : const LinearGradient(
                  colors: <Color>[AppColors.disabledBg, AppColors.disabledBg],
                ),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: enabled ? AppColors.brandBright : AppColors.borderSoft,
            width: 1,
          ),
          boxShadow: enabled ? AppShadows.buttonGlow : const <BoxShadow>[],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: onPressed,
            child: Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: enabled
                            ? const Color(0xFF2A1707)
                            : AppColors.disabledFg,
                        size: 18,
                      ),
                      child: icon!,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? const Color(0xFF2A1707)
                          : AppColors.disabledFg,
                      fontSize: AppTextSize.md,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
