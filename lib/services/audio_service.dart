import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/play_list_model/albam.dart';
import 'package:medyo/features/theme/misc_provider.dart';

final isAudioPaused = StateProvider<bool>((ref) => false);
final playBackDurationProvider =
    StateProvider<Duration>((ref) => Duration.zero);
final audioServiceProvider =
    StateNotifierProvider<AudioHandlerNotifier, AudioHandler?>((ref) {
  return AudioHandlerNotifier(ref);
});

class AudioHandlerNotifier extends StateNotifier<AudioHandler?> {
  AudioHandlerNotifier(this.ref) : super(null) {
    initAudioService();
  }
  final Ref ref;

  Future<void> initAudioService() async {
    state ??= await AudioService.init(
      builder: () => MyAudioHandler(ref),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.razinsoft.maditam.audio',
        androidNotificationChannelName: 'Maditam',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final Ref ref;

  MyAudioHandler(this.ref) {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.positionStream.listen((event) {
      ref.watch(playBackDurationProvider.notifier).state = event;
      if (_player.duration != null &&
          (_player.duration!.inSeconds - event.inSeconds) < 1) {
        skipToNext();
      }
    });
  }

  @override
  Future<void> play() {
    ref.watch(isAudioPaused.notifier).state = false;
    ref.watch(bottomShow.notifier).state = true;
    final audioplayer = ref.watch(audioPlayerProvider);
    audioplayer.stop();
    return _player.play();
  }

  @override
  Future<void> pause() {
    ref.watch(isAudioPaused.notifier).state = true;
    ref.watch(bottomShow.notifier).state = false;
    return _player.pause();
  }

  @override
  Future<void> skipToNext() {
    ref.watch(bottomShow.notifier).state = true;
    final playList = ref.read(currentPlayListProvider);
    final musicIndex = ref.read(selectedMusicIndex);

    if (musicIndex < playList.length - 1) {
      ref.watch(selectedMusicIndex.notifier).update((state) {
        final newState = state + 1;
        final music = playList[newState];

        _playNewItem(music, true);
        return newState;
      });
    }

    return super.skipToNext();
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    this.mediaItem.drain();
    final dur =
        await _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));

    this.mediaItem.add(mediaItem.copyWith(duration: dur));
  }

  @override
  Future<void> skipToPrevious() {
    ref.watch(bottomShow.notifier).state = true;
    final playList = ref.read(currentPlayListProvider);
    final musicIndex = ref.read(selectedMusicIndex);

    if (musicIndex > 0) {
      ref.watch(selectedMusicIndex.notifier).update((state) {
        final newState = state - 1;
        final music = playList[newState];

        _playNewItem(music, true);
        return newState;
      });
    }
    return super.skipToPrevious();
  }

  _playNewItem(MusicTrack music, bool stopPlay) async {
    Duration? dur;
    if (stopPlay) {
      stop();
      dur = await _player
          .setAudioSource(AudioSource.uri(Uri.parse(music.audio ?? '')));
    }

    mediaItem.drain();

    mediaItem.add(MediaItem(
      id: music.audio.toString(),
      album: '${music.albam?.name}',
      title: music.name ?? '',
      duration: dur,
      extras: {
        'isFav': music.isfavorite,
        'id': music.id.toString(),
        'album': music.albam?.id.toString(),
        'desc': music.description,
        'hasReadMore': music.hasReadMore,
        'thumbnail': music.thumbnail,
      },
      artUri: Uri.parse(music.thumbnail ?? ''),
    ));
    if (stopPlay) {
      play();
    }
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() {
    ref.watch(isAudioPaused.notifier).state = false;
    return _player.stop();
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
