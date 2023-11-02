import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sceneProvider = StateProvider<String>((ref) {
  return "";
});
final musicProvider = StateProvider<String>((ref) {
  return "";
});
final volumeprovider = StateProvider<bool>((ref) {
  return false;
});

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final audioPlayerNotifierProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayer>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return AudioPlayerNotifier(audioPlayer);
});

class AudioPlayerNotifier extends StateNotifier<AudioPlayer> {
  AudioPlayerNotifier(AudioPlayer audioPlayer) : super(audioPlayer);

  Future<void> play(String url) async {
    await state.play(AssetSource(url));
  }

  Future<void> pause() async {
    await state.pause();
  }

  Future<void> setVolume(double volume) async {
    await state.setVolume(volume);
  }

  Future<void> setLoop(bool isLooping) async {
    await state.setReleaseMode(isLooping ? ReleaseMode.loop : ReleaseMode.stop);
  }
}
