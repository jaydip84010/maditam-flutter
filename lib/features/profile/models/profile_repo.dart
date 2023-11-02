import 'package:dio/dio.dart';
import 'package:medyo/features/profile/models/privacy_and_policy_model/privacy_and_policy_model.dart';

abstract class IProfileRepo {
  IProfileRepo(this.dio);
  final Dio dio;
  Future<PrivacyAndPolicyModel> getPrivacyAndPolicy();
}

class ProfileRepo implements IProfileRepo {
  ProfileRepo(this.dio);
  @override
  final Dio dio;

  @override
  Future<PrivacyAndPolicyModel> getPrivacyAndPolicy() async {
    var response = await dio.get("/legal-pages/privacy-policy");
    print("DDD ${response.data}");
    print("DDD ${PrivacyAndPolicyModel.fromMap(response.data)}");
    return PrivacyAndPolicyModel.fromMap(response.data);
  }
}
