import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/auth/logic/auth_notfier.dart';
import 'package:medyo/features/auth/models/auth_repo.dart';
import 'package:medyo/features/auth/models/login_model/login_model.dart';
import 'package:medyo/features/core/logic/app_config_provider.dart';
import 'package:medyo/services/api_state.dart';

final authRepoProvider = Provider<IAUthRepo>((ref) {
  return AuthRepo(ref.watch(dioProvider));
});

final loginProvider =
    StateNotifierProvider<LoginNotifier, ApiState<LoginModel>>((ref) {
  return LoginNotifier(ref.watch(authRepoProvider));
});

final registerProvider =
    StateNotifierProvider<RegisterNotifier, ApiState<LoginModel>>((ref) {
  return RegisterNotifier(ref.watch(authRepoProvider));
});
final logoutProvider =
    StateNotifierProvider<LogOutNotifier, ApiState<String>>((ref) {
  return LogOutNotifier(ref.watch(authRepoProvider));
});

final verificationMailProvider =
    StateNotifierProvider<ResendMailNotifier, ApiState<String>>((ref) {
  return ResendMailNotifier(ref.watch(authRepoProvider));
});

final changePassProvider =
    StateNotifierProvider<ChangePassNotifier, ApiState<String>>((ref) {
  return ChangePassNotifier(ref.watch(authRepoProvider));
});

final changePhotoProvider =
    StateNotifierProvider<ChangePhotoNotifier, ApiState<String>>((ref) {
  return ChangePhotoNotifier(ref.watch(authRepoProvider));
});
final sendOtpMailProvider =
    StateNotifierProvider<SendOtpMailNotifier, ApiState<String>>((ref) {
  return SendOtpMailNotifier(ref.watch(authRepoProvider));
});
final verifyOtpProvider =
    StateNotifierProvider<VerifyOtpNotifier, ApiState<Map<String, dynamic>>>(
        (ref) {
  return VerifyOtpNotifier(ref.watch(authRepoProvider));
});
final resetPassProvider =
    StateNotifierProvider<ResetPassNotifier, ApiState<String>>((ref) {
  return ResetPassNotifier(ref.watch(authRepoProvider));
});

final forgotPassTimeProvider =
    StateNotifierProvider<ForgotPassTimerNotifier, int>((ref) {
  return ForgotPassTimerNotifier();
});
