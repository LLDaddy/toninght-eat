import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/geo_cuisine_mapping.dart';
import '../l10n/l10n_ext.dart';
import '../services/profile_service.dart';
import '../ui/app_tokens.dart';
import '../ui/components/app_scaffold.dart';
import '../ui/components/primary_button.dart';
import '../ui/components/section_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _dislikedInputController = TextEditingController();
  final _familySizeController = TextEditingController();
  final ProfileService _profileService = ProfileService();

  final List<String> _tasteOptions = ['清淡', '重口', '辣', '酸甜', '咸鲜'];
  final List<String> _menuPatterns = ['2菜1汤', '3菜1汤', '4菜1汤'];

  String? _selectedProvince;
  String? _selectedCity;
  final Set<String> _preferredCuisines = <String>{};
  final Set<String> _selectedTastes = <String>{};
  final Set<String> _dislikedIngredients = <String>{};
  String? _selectedMenuPattern;
  bool _saving = false;

  @override
  void dispose() {
    _dislikedInputController.dispose();
    _familySizeController.dispose();
    super.dispose();
  }

  void _addDislikedIngredient() {
    final value = _dislikedInputController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _dislikedIngredients.add(value);
      _dislikedInputController.clear();
    });
  }

  Future<void> _saveOnboarding() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvince == null ||
        _selectedCity == null ||
        _selectedMenuPattern == null ||
        _selectedTastes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingRequiredFieldsIncomplete)),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingSessionExpired)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final region = inferRegionFromProvince(_selectedProvince);
      await _profileService.upsertOnboarding(
        userId: user.id,
        phone: user.phone ?? '',
        region: region,
        province: _selectedProvince!,
        city: _selectedCity!,
        preferredCuisines: _preferredCuisines.toList(),
        familySize: int.parse(_familySizeController.text.trim()),
        tastePrefs: _selectedTastes.toList(),
        dislikedIngredients: _dislikedIngredients.toList(),
        menuPattern: _selectedMenuPattern!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingSaveSuccess)),
      );
      // 保存后回到根路由，AuthGate 会自动跳到首页。
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.onboardingSaveFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildRegionAndFamilySection() {
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingSectionRegionFamily,
            style: TextStyle(
              fontSize: AppTextSize.lg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _selectedProvince,
            decoration:
                InputDecoration(labelText: l10n.onboardingProvinceLabel),
            items: provinceCityOptions.keys
                .map((province) => DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedProvince = value;
                _selectedCity = null;
              });
            },
            validator: (value) =>
                value == null ? l10n.onboardingProvinceRequired : null,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _selectedCity,
            decoration: InputDecoration(labelText: l10n.onboardingCityLabel),
            items: (_selectedProvince == null
                    ? const <String>[]
                    : provinceCityOptions[_selectedProvince] ??
                        const <String>[])
                .map((city) => DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedCity = value),
            validator: (value) =>
                value == null ? l10n.onboardingCityRequired : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _familySizeController,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: l10n.onboardingFamilySizeLabel),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.onboardingFamilySizeRequired;
              }
              final parsed = int.tryParse(value.trim());
              if (parsed == null || parsed <= 0 || parsed > 20) {
                return l10n.onboardingFamilySizeRangeInvalid;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceSection() {
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingSectionPreferences,
            style: TextStyle(
              fontSize: AppTextSize.lg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.onboardingPreferredCuisinesLabel),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: supportedCuisines.map((cuisine) {
              final selected = _preferredCuisines.contains(cuisine);
              return FilterChip(
                label: Text(cuisine),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _preferredCuisines.add(cuisine);
                    } else {
                      _preferredCuisines.remove(cuisine);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.onboardingTastePreferencesLabel),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: _tasteOptions.map((taste) {
              final selected = _selectedTastes.contains(taste);
              return FilterChip(
                label: Text(taste),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _selectedTastes.add(taste);
                    } else {
                      _selectedTastes.remove(taste);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDislikedSection() {
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingSectionDisliked,
            style: TextStyle(
              fontSize: AppTextSize.lg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.onboardingDislikedLabel),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dislikedInputController,
                  decoration: InputDecoration(
                    hintText: l10n.onboardingDislikedHint,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(
                onPressed: _addDislikedIngredient,
                child: Text(l10n.onboardingAdd),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: _dislikedIngredients.map((item) {
              return InputChip(
                label: Text(item),
                onDeleted: () =>
                    setState(() => _dislikedIngredients.remove(item)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuPatternSection() {
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingSectionMenuPattern,
            style: TextStyle(
              fontSize: AppTextSize.lg,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _selectedMenuPattern,
            decoration:
                InputDecoration(labelText: l10n.onboardingMenuPatternLabel),
            items: _menuPatterns
                .map((pattern) => DropdownMenuItem(
                      value: pattern,
                      child: Text(pattern),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedMenuPattern = value),
            validator: (value) =>
                value == null ? l10n.onboardingMenuPatternRequired : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppScaffold(
      title: l10n.onboardingTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRegionAndFamilySection(),
              const SizedBox(height: AppSpacing.md),
              _buildPreferenceSection(),
              const SizedBox(height: AppSpacing.md),
              _buildDislikedSection(),
              const SizedBox(height: AppSpacing.md),
              _buildMenuPatternSection(),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: _saving ? l10n.onboardingSaving : l10n.onboardingSave,
                expanded: true,
                onPressed: _saving ? null : _saveOnboarding,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
