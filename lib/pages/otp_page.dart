import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../services/auth_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/section_card.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phone});

  final String phone;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _authService.verifyOtp(
        phone: widget.phone,
        token: _otpController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.otpLoginSuccess)));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otpVerifyFailed(e.toString()))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.otpTitle,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.otpSentTo(widget.phone),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.otpCodeLabel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.otpCodeRequired;
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                      return l10n.otpCodeInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: _loading ? l10n.otpVerifying : l10n.otpVerifyAndLogin,
                  expanded: true,
                  onPressed: _loading ? null : _verifyOtp,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_user_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
