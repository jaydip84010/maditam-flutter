import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/core/logic/app_config_provider.dart';
import 'package:medyo/features/profile/logic/profile_notifier.dart';
import 'package:medyo/features/profile/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:medyo/features/profile/models/profile_repo.dart';
import 'package:medyo/services/api_state.dart';

final profileRepoProvider = Provider<IProfileRepo>((ref) {
  return ProfileRepo(ref.watch(dioProvider));
});

final privacyAndPolicyProvider = StateNotifierProvider<PrivacyAndPolicyNotifier,
    ApiState<PrivacyAndPolicyModel>>((ref) {
  return PrivacyAndPolicyNotifier(ref.watch(profileRepoProvider));
});
