import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerLoadingProvider = StateNotifierProvider((ref) {
  return PlayerLoading();
});

class PlayerLoading extends StateNotifier<bool> {
  PlayerLoading() : super(false);
  void startLoading(bool isLoading) {
    state = isLoading;
  }

  void stopLoading(bool isLoading) {
    state = isLoading;
  }
}

// final playerChangeNotifierProvider =
//     ChangeNotifierProvider<PlayerNotifier>((ref) {
//   return PlayerNotifier();
// });

// class PlayerNotifier extends ChangeNotifier {
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   void startLoading(bool isLoading) {
//     _isLoading = isLoading;
//     notifyListeners();
//   }

//   void stopLoading(bool isLoading) {
//     _isLoading = isLoading;
//     notifyListeners();
//   }
// }
