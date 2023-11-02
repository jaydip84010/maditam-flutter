import 'package:dio/dio.dart';
import 'package:medyo/features/favourites/models/favourite_list_model/favourite_list_model.dart';

abstract class IFavRepo {
  IFavRepo(this.dio);
  final Dio dio;
  Future<void> favUnFav({required String id});
  Future<FavouriteListModel> getFav();
}

class FavRepo implements IFavRepo {
  FavRepo(this.dio);

  @override
  final Dio dio;

  @override
  Future<void> favUnFav({required String id}) async {
    await dio.post("/favorites", data: {'play_list_id': id});
  }

  @override
  Future<FavouriteListModel> getFav() async {
    var response = await dio.get(
      "/favorites",
    );
    return FavouriteListModel.fromMap(response.data);
  }
}
