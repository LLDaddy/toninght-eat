import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class AuthService {
  Future<void> sendOtp({required String phone}) async {
    await SupabaseService.client.auth.signInWithOtp(phone: phone);
  }

  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return SupabaseService.client.auth.verifyOTP(
      type: OtpType.sms,
      phone: phone,
      token: token,
    );
  }

  User? get currentUser => SupabaseService.client.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      SupabaseService.client.auth.onAuthStateChange;
}
