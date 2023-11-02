import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medyo/features/core/logic/app_config_provider.dart';
import 'package:medyo/features/favourites/logic/fav_notifiers.dart';
import 'package:medyo/features/favourites/models/fav_repo.dart';
import 'package:medyo/features/favourites/models/favourite_list_model/favourite_list_model.dart';
import 'package:medyo/services/api_state.dart';

final favRepoProvider = Provider<IFavRepo>((ref) {
  return FavRepo(ref.read(dioProvider));
});

final favListProvider =
    StateNotifierProvider<FavListNotifier, ApiState<FavouriteListModel>>((ref) {
  return FavListNotifier(ref.watch(favRepoProvider));
});

final favunfavProvider = StateNotifierProvider.family
    .autoDispose<FavUnFavNotifier, ApiState<String>, String>((ref, id) {
  return FavUnFavNotifier(ref.watch(favRepoProvider), id);
});
