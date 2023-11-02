import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/profile/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:medyo/features/profile/models/profile_repo.dart';
import 'package:medyo/services/api_state.dart';
import 'package:medyo/services/network_exceptions.dart';

class PrivacyAndPolicyNotifier
    extends StateNotifier<ApiState<PrivacyAndPolicyModel>> {
  PrivacyAndPolicyNotifier(this.repo) : super(const ApiState.initial()) {
    getPrivacyAndPolicy();
  }
  final IProfileRepo? repo;
  Future<void> getPrivacyAndPolicy() async {
    state = const ApiState.loading();
    try {
      final privacyAndPolicyModel = await repo!.getPrivacyAndPolicy();
      state = ApiState.loaded(data: privacyAndPolicyModel);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
