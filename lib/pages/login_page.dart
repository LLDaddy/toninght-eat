import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../services/auth_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/section_card.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String _normalizePhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.startsWith('+')) {
      return digits;
    }
    // 默认按中国手机号补区号，可按业务调整。
    return '+86$digits';
  }

  Future<void> _sendOtp() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final phone = _normalizePhone(_phoneController.text.trim());
    try {
      await _authService.sendOtp(phone: phone);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.loginOtpSent)));
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OtpPage(phone: phone)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loginSendFailed(e.toString()))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.loginTitle,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.loginInstruction,
                  style: TextStyle(
                    fontSize: AppTextSize.md,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.loginPhoneLabel,
                    hintText: l10n.loginPhoneHint,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.loginPhoneRequired;
                    }
                    final cleaned = value.replaceAll(RegExp(r'[^0-9+]'), '');
                    final e164 =
                        cleaned.startsWith('+') ? cleaned : '+86$cleaned';
                    if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(e164)) {
                      return l10n.loginPhoneInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: _loading ? l10n.loginSending : l10n.loginSendOtp,
                  expanded: true,
                  onPressed: _loading ? null : _sendOtp,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sms_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
