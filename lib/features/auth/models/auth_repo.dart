import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medyo/features/auth/models/login_model/login_model.dart';

abstract class IAUthRepo {
  IAUthRepo(this.dio);
  final Dio dio;
  Future<LoginModel> login({required String email, required String password});
  Future<LoginModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<void> logOut();
  Future<void> verificationMail();
  Future<void> changePass({required Map<String, dynamic> data});
  Future<void> changeProfilePhoto({required File file});
  Future<void> sendOtpToMail({required String email});
  Future<Map<String, dynamic>> verifyOtp(
      {required String email, required String otp});
  Future<void> resetPass(
      {required String resetToken,
      required String password,
      required String passwordConfirmation});
}

class AuthRepo implements IAUthRepo {
  AuthRepo(this.dio);
  @override
  final Dio dio;
  @override
  Future<LoginModel> login(
      {required String email, required String password}) async {
    final token = await FirebaseMessaging.instance.getToken();
    var response = await dio.post("/sign-in", data: {
      "email": email,
      "password": password,
      'device_key': token,
      'device_type': Platform.isAndroid ? 'android' : 'ios'
    });

    return LoginModel.fromMap(response.data);
  }

  @override
  Future<LoginModel> register(
      {required String email,
      required String password,
      required String name}) async {
    final token = await FirebaseMessaging.instance.getToken();
    var response = await dio.post("/sign-up", data: {
      "name": name,
      "email": email,
      "password": password,
      'device_key': token,
      'device_type': Platform.isAndroid ? 'android' : 'ios'
    });

    return LoginModel.fromMap(response.data);
  }

  @override
  Future<void> logOut() async {
    await dio.get("/logout");
  }

  @override
  Future<void> verificationMail() async {
    await dio.get("/resend-token");
  }

  @override
  Future<void> changePass({required Map<String, dynamic> data}) async {
    await dio.post("/update-password", data: data);
  }

  @override
  Future<void> changeProfilePhoto({required File file}) async {
    final ext = file.path.split('.').last;
    await dio.post("/update/profile-photo",
        data: FormData.fromMap({
          "image": await MultipartFile.fromFile(
            file.path,
            filename:
                "${DateTime.now().millisecondsSinceEpoch.toString()}.$ext",
          ),
        }));
  }

  @override
  Future<void> sendOtpToMail({required String email}) async {
    await dio.post("/forgot-password", data: {'email': email});
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(
      {required String email, required String otp}) async {
    var response =
        await dio.post("/verify-otp", data: {'email': email, 'otp': otp});
    return response.data;
  }

  @override
  Future<void> resetPass(
      {required String resetToken,
      required String password,
      required String passwordConfirmation}) async {
    await dio.post("/reset-password", data: {
      'reset_token': resetToken,
      'password': password,
      'password_confirmation': passwordConfirmation
    });
  }
}
