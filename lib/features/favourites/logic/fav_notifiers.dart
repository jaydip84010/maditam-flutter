import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/favourites/models/fav_repo.dart';
import 'package:medyo/features/favourites/models/favourite_list_model/favourite_list_model.dart';
import 'package:medyo/services/api_state.dart';
import 'package:medyo/services/network_exceptions.dart';

class FavListNotifier extends StateNotifier<ApiState<FavouriteListModel>> {
  FavListNotifier(
    this._repo,
  ) : super(const ApiState.initial()) {
    getFav();
  }
  final IFavRepo _repo;

  Future<void> getFav() async {
    state = const ApiState.loading();
    try {
      final sections = await _repo.getFav();
      state = ApiState.loaded(data: sections);
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class FavUnFavNotifier extends StateNotifier<ApiState<String>> {
  FavUnFavNotifier(
    this._repo,
    this.id,
  ) : super(const ApiState.initial());
  final IFavRepo _repo;
  final String id;

  Future<void> favUnFav() async {
    state = const ApiState.loading();
    try {
      await _repo.favUnFav(id: id);
      state = const ApiState.loaded(data: 'Success');
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
