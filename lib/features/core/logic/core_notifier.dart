import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/core/models/album_list_model/album_list_model.dart';
import 'package:medyo/features/core/models/app_banner_list_model/app_banner_list_model.dart';
import 'package:medyo/features/core/models/category_list_model/category_list_model.dart';
import 'package:medyo/features/core/models/core_repo.dart';
import 'package:medyo/features/core/models/dashboard_category_a_lbums_list/dashboard_category_a_lbums_list.dart';
import 'package:medyo/features/core/models/music_details_model/music_details_model.dart';
import 'package:medyo/features/core/models/my_subscription_model/my_subscription_model.dart';
import 'package:medyo/features/core/models/play_list_model/play_list_model.dart';
import 'package:medyo/features/core/models/premium_list_model/premium_list_model.dart';
import 'package:medyo/features/core/models/user_model/user_model.dart';
import 'package:medyo/services/api_state.dart';
import 'package:medyo/services/network_exceptions.dart';
import 'package:medyo/utils/global_function.dart';

class CategoryNotifier extends StateNotifier<ApiState<CategoryListModel>> {
  CategoryNotifier(this._repo) : super(const ApiState.initial()) {
    getCategories();
  }
  final ICoreRepo _repo;

  Future<void> getCategories() async {
    state = const ApiState.loading();
    try {
      final sections = await _repo.getCategories();
      state = ApiState.loaded(data: sections);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AlbumsNotifier extends StateNotifier<ApiState<AlbumListModel>> {
  AlbumsNotifier(this._repo, this.categoryID)
      : super(const ApiState.initial()) {
    getAlbum();
  }
  final ICoreRepo _repo;
  final String categoryID;

  Future<void> getAlbum() async {
    state = const ApiState.loading();
    try {
      final sections = await _repo.getAlbum(categoryID: categoryID);
      state = ApiState.loaded(data: sections);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class TracksNotifier extends StateNotifier<ApiState<PlayListModel>> {
  TracksNotifier(this._repo, this.albumID) : super(const ApiState.initial()) {
    getTrack();
  }
  final ICoreRepo _repo;
  final String albumID;

  Future<void> getTrack() async {
    state = const ApiState.loading();
    try {
      final sections = await _repo.getTracks(albumID: albumID);
      state = ApiState.loaded(data: sections);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class UserNotifier extends StateNotifier<ApiState<UserModel>> {
  UserNotifier(
    this._repo,
  ) : super(const ApiState.initial()) {
    getUser();
  }
  final ICoreRepo _repo;

  Future<void> getUser() async {
    state = const ApiState.loading();
    try {
      final user = await _repo.getUser();

      //Update User Data in Hive
      if (user.data != null) {
        AppGLF.updateUserData(user.data!);
      }

      state = ApiState.loaded(data: user);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AllSubListNotifier extends StateNotifier<ApiState<PremiumListModel>> {
  AllSubListNotifier(
    this._repo,
  ) : super(const ApiState.initial()) {
    getPremiums();
  }
  final ICoreRepo _repo;

  Future<void> getPremiums() async {
    state = const ApiState.loading();
    try {
      final user = await _repo.getPremiums();

      state = ApiState.loaded(data: user);
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class MySubsNotifier extends StateNotifier<ApiState<MySubscriptionModel>> {
  MySubsNotifier(
    this._repo,
  ) : super(const ApiState.initial()) {
    getSubscriptions();
  }
  final ICoreRepo _repo;

  Future<void> getSubscriptions() async {
    state = const ApiState.loading();
    try {
      final user = await _repo.getSubscriptions();

      state = ApiState.loaded(data: user);
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class DashboardCategoryALbumsListNotifier
    extends StateNotifier<ApiState<DashboardCategoryALbumsList>> {
  DashboardCategoryALbumsListNotifier(this._repo, this.type)
      : super(const ApiState.initial()) {
    getDashboardCategoryAlbumList();
  }
  final ICoreRepo _repo;
  final String type;

  Future<void> getDashboardCategoryAlbumList({int? perPage, int? page}) async {
    state = const ApiState.loading();
    try {
      final user = await _repo.getDashboardCategoryAlbumList(
          type: type, perPage: perPage ?? 5, page: page ?? 1);
      state = ApiState.loaded(data: user);
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class AppBannersNotifier extends StateNotifier<ApiState<AppBannerListModel>> {
  AppBannersNotifier(this._repo) : super(const ApiState.initial()) {
    getBanner();
  }
  final ICoreRepo _repo;

  Future<void> getBanner() async {
    state = const ApiState.loading();
    try {
      final sections = await _repo.getBanners();
      state = ApiState.loaded(data: sections);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class MusicDetailsNotifier extends StateNotifier<ApiState<MusicDetailsModel>> {
  MusicDetailsNotifier(this._repo, this.musicID)
      : super(const ApiState.initial()) {
    getMusicDetails();
  }
  final ICoreRepo _repo;
  final String musicID;

  Future<void> getMusicDetails() async {
    state = const ApiState.loading();
    try {
      final data = await _repo.getMusicDetails(musicId: musicID);
      state = ApiState.loaded(data: data);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
