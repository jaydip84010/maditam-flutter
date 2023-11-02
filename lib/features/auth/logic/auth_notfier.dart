import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/auth/models/auth_repo.dart';
import 'package:medyo/features/auth/models/login_model/login_model.dart';
import 'package:medyo/services/api_state.dart';
import 'package:medyo/services/network_exceptions.dart';

class LoginNotifier extends StateNotifier<ApiState<LoginModel>> {
  LoginNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> login({required String email, required String password}) async {
    state = const ApiState.loading();
    try {
      final loginModel =
          await _authRepo.login(email: email, password: password);
      state = ApiState.loaded(data: loginModel);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class RegisterNotifier extends StateNotifier<ApiState<LoginModel>> {
  RegisterNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const ApiState.loading();
    try {
      final loginModel = await _authRepo.register(
          email: email, password: password, name: name);
      state = ApiState.loaded(data: loginModel);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class LogOutNotifier extends StateNotifier<ApiState<String>> {
  LogOutNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> logOut() async {
    state = const ApiState.loading();
    try {
      await _authRepo.logOut();
      state = const ApiState.loaded(data: "Success");
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ResendMailNotifier extends StateNotifier<ApiState<String>> {
  ResendMailNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> verificationMail() async {
    state = const ApiState.loading();
    try {
      await _authRepo.verificationMail();
      EasyLoading.showSuccess("Verification mail sent");
      state = const ApiState.loaded(data: "Success");
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ChangePassNotifier extends StateNotifier<ApiState<String>> {
  ChangePassNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> changePass({required Map<String, dynamic> data}) async {
    state = const ApiState.loading();
    try {
      await _authRepo.changePass(data: data);
      EasyLoading.showSuccess("Password changed");
      state = const ApiState.loaded(data: "Success");
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ChangePhotoNotifier extends StateNotifier<ApiState<String>> {
  ChangePhotoNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> changeProfilePhoto({required File file}) async {
    state = const ApiState.loading();
    try {
      await _authRepo.changeProfilePhoto(file: file);
      EasyLoading.showSuccess("Profile Picture changed");
      state = const ApiState.loaded(data: "Success");
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class SendOtpMailNotifier extends StateNotifier<ApiState<String>> {
  SendOtpMailNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> sendOtpToMail({required String email}) async {
    state = const ApiState.loading();
    try {
      await _authRepo.sendOtpToMail(email: email);
      EasyLoading.showSuccess("Otp Sent TO your Email");
      state = const ApiState.loaded(data: "Success");
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class VerifyOtpNotifier extends StateNotifier<ApiState<Map<String, dynamic>>> {
  VerifyOtpNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
          data: await _authRepo.verifyOtp(email: email, otp: otp));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ResetPassNotifier extends StateNotifier<ApiState<String>> {
  ResetPassNotifier(this._authRepo) : super(const ApiState.initial());

  final IAUthRepo _authRepo;

  Future<void> resetPass(
      {required String resetToken,
      required String password,
      required String passwordConfirmation}) async {
    state = const ApiState.loading();
    try {
      await _authRepo.resetPass(
          resetToken: resetToken,
          password: password,
          passwordConfirmation: passwordConfirmation);
      state = const ApiState.loaded(data: 'Success');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class ForgotPassTimerNotifier extends StateNotifier<int> {
  ForgotPassTimerNotifier() : super(0);
  // ignore: unused_field, use_late_for_private_fields_and_variables
  Timer? _timer;

  Future<void> startTimer() async {
    state = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != 0) {
        state = state - 1;
      } else {
        timer.cancel();
      }
    });
  }
}
