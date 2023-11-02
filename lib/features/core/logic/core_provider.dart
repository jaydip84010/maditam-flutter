import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/core/logic/app_config_provider.dart';
import 'package:medyo/features/core/logic/core_notifier.dart';
import 'package:medyo/features/core/models/album_list_model/albam.dart';
import 'package:medyo/features/core/models/album_list_model/album_list_model.dart';
import 'package:medyo/features/core/models/app_banner_list_model/app_banner_list_model.dart';
import 'package:medyo/features/core/models/category_list_model/category_list_model.dart';
import 'package:medyo/features/core/models/core_repo.dart';
import 'package:medyo/features/core/models/dashboard_category_a_lbums_list/dashboard_category_a_lbums_list.dart';
import 'package:medyo/features/core/models/dashboard_category_a_lbums_list/albam.dart'
    as hAlbam;
import 'package:medyo/features/core/models/music_details_model/music_details_model.dart';
import 'package:medyo/features/core/models/my_subscription_model/my_subscription_model.dart';
import 'package:medyo/features/core/models/play_list_model/albam.dart';
import 'package:medyo/features/core/models/play_list_model/play_list_model.dart';
import 'package:medyo/features/core/models/premium_list_model/premium_list_model.dart';
import 'package:medyo/features/core/models/user_model/user_model.dart';
import 'package:medyo/services/api_state.dart';

final coreRepoProvider = Provider<ICoreRepo>((ref) {
  return CoreRepo(ref.read(dioProvider));
});

final categoriessProvider =
    StateNotifierProvider<CategoryNotifier, ApiState<CategoryListModel>>((ref) {
  return CategoryNotifier(ref.watch(coreRepoProvider));
});

final albumsProvider = StateNotifierProvider.family<AlbumsNotifier,
    ApiState<AlbumListModel>, String>((ref, id) {
  return AlbumsNotifier(ref.watch(coreRepoProvider), id);
});

final tracksProvider = StateNotifierProvider.family<TracksNotifier,
    ApiState<PlayListModel>, String>((ref, id) {
  return TracksNotifier(ref.watch(coreRepoProvider), id);
});

final userProvider =
    StateNotifierProvider<UserNotifier, ApiState<UserModel>>((ref) {
  return UserNotifier(ref.watch(coreRepoProvider));
});

final selectedAlbumProvider = StateProvider<Albam?>((ref) {
  return null;
});
final selectedMusicProvider = StateProvider<String?>((ref) {
  return null;
});
final selectedDatumProvider = StateProvider<hAlbam.Albam?>((ref) {
  return null;
});

final selectedMusicIndex = StateProvider<int>((ref) {
  return 0;
});

final currentPlayListProvider = StateProvider<List<MusicTrack>>((ref) {
  return [];
});

//Premium Providers
final allPremiumsProvider =
    StateNotifierProvider<AllSubListNotifier, ApiState<PremiumListModel>>(
        (ref) {
  return AllSubListNotifier(ref.watch(coreRepoProvider));
});
final mySubProvider =
    StateNotifierProvider<MySubsNotifier, ApiState<MySubscriptionModel>>((ref) {
  return MySubsNotifier(ref.watch(coreRepoProvider));
});
final dashboardcategoryalbumListProvider = StateNotifierProvider.family<
    DashboardCategoryALbumsListNotifier,
    ApiState<DashboardCategoryALbumsList>,
    String>((ref, type) {
  return DashboardCategoryALbumsListNotifier(ref.watch(coreRepoProvider), type);
});

final appBannersProvider =
    StateNotifierProvider<AppBannersNotifier, ApiState<AppBannerListModel>>(
        (ref) {
  return AppBannersNotifier(ref.watch(coreRepoProvider));
});

final bottomPlayerOffset = StateProvider.family<double, String>((ref, name) {
  return 0;
});

final bottomShow = StateProvider<bool>((ref) {
  return true;
});

final musicDetaislProvider = StateNotifierProvider.family<MusicDetailsNotifier,
    ApiState<MusicDetailsModel>, String>((ref, id) {
  return MusicDetailsNotifier(ref.watch(coreRepoProvider), id);
});
