import 'package:dio/dio.dart';
import 'package:medyo/features/core/models/album_list_model/album_list_model.dart';
import 'package:medyo/features/core/models/app_banner_list_model/app_banner_list_model.dart';
import 'package:medyo/features/core/models/category_list_model/category_list_model.dart';
import 'package:medyo/features/core/models/dashboard_category_a_lbums_list/dashboard_category_a_lbums_list.dart';
import 'package:medyo/features/core/models/music_details_model/music_details_model.dart';
import 'package:medyo/features/core/models/my_subscription_model/my_subscription_model.dart';
import 'package:medyo/features/core/models/play_list_model/play_list_model.dart';
import 'package:medyo/features/core/models/premium_list_model/premium_list_model.dart';
import 'package:medyo/features/core/models/user_model/user_model.dart';

abstract class ICoreRepo {
  ICoreRepo(this.dio);
  final Dio dio;
  Future<CategoryListModel> getCategories();
  Future<AlbumListModel> getAlbum({required String categoryID});
  Future<PlayListModel> getTracks({required String albumID});
  Future<UserModel> getUser();
  Future<PremiumListModel> getPremiums();
  Future<MySubscriptionModel> getSubscriptions();
  Future<DashboardCategoryALbumsList> getDashboardCategoryAlbumList(
      {required String type, required int perPage, required int page});
  Future<AppBannerListModel> getBanners();
  Future<MusicDetailsModel> getMusicDetails({required String musicId});
}

class CoreRepo implements ICoreRepo {
  CoreRepo(this.dio);
  @override
  final Dio dio;

  @override
  Future<CategoryListModel> getCategories() async {
    var response = await dio.get(
      "/categories",
    );
    return CategoryListModel.fromMap(response.data);
  }

  @override
  Future<AlbumListModel> getAlbum({required String categoryID}) async {
    var response =
        await dio.get("/albams", queryParameters: {'category': categoryID});
    return AlbumListModel.fromMap(response.data);
  }

  @override
  Future<PlayListModel> getTracks({required String albumID}) async {
    var response =
        await dio.get("/play-lists", queryParameters: {'albam': albumID});
    return PlayListModel.fromMap(response.data);
  }

  @override
  Future<UserModel> getUser() async {
    var response = await dio.get("/profiles");
    return UserModel.fromMap(response.data);
  }

  @override
  Future<PremiumListModel> getPremiums() async {
    var response = await dio.get("/subscription/plans");
    return PremiumListModel.fromMap(response.data);
  }

  @override
  Future<MySubscriptionModel> getSubscriptions() async {
    var response = await dio.get("/my-subscription/plans");
    return MySubscriptionModel.fromMap(response.data);
  }

  @override
  Future<DashboardCategoryALbumsList> getDashboardCategoryAlbumList(
      {required String type, required int perPage, required int page}) async {
    var response = await dio.get("/shift",
        queryParameters: {"type": type, "perPage": perPage, 'page': page});

    return DashboardCategoryALbumsList.fromMap(response.data);
  }

  @override
  Future<AppBannerListModel> getBanners() async {
    var response = await dio.get("/banner");
    return AppBannerListModel.fromMap(response.data);
  }

  @override
  Future<MusicDetailsModel> getMusicDetails({required String musicId}) async {
    var response = await dio.get("/play-lists/$musicId/content");
    return MusicDetailsModel.fromMap(response.data);
  }
}
