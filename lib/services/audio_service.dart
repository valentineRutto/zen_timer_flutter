import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  late AudioPlayer _ambientPlayer;
  late AudioPlayer _completionPlayer;

  AudioService._internal() {
    _ambientPlayer = AudioPlayer();
    _completionPlayer = AudioPlayer();
  }

  factory AudioService() {
    return _instance;
  }

  Future<void> playAmbientSound(String url) async {
    try {
      await _ambientPlayer.setUrl(url);
      await _ambientPlayer.setLoopMode(LoopMode.one);
      await _ambientPlayer.play();
    } catch (e) {
      debugPrint('Error playing ambient sound: $e');
    }
  }

  Future<void> pauseAmbientSound() async {
    try {
      await _ambientPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing ambient sound: $e');
    }
  }

  Future<void> resumeAmbientSound() async {
    try {
      if (_ambientPlayer.position != Duration.zero) {
        await _ambientPlayer.play();
      }
    } catch (e) {
      debugPrint('Error resuming ambient sound: $e');
    }
  }

  Future<void> stopAmbientSound() async {
    try {
      await _ambientPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping ambient sound: $e');
    }
  }

  Future<void> setAmbientVolume(double volume) async {
    try {
      await _ambientPlayer.setVolume(volume);
    } catch (e) {
      debugPrint('Error setting ambient volume: $e');
    }
  }

  Future<void> playCompletionSound(String url) async {
    try {
      await _completionPlayer.setUrl(url);
      await _completionPlayer.play();
    } catch (e) {
      debugPrint('Error playing completion sound: $e');
    }
  }

  Future<void> dispose() async {
    await _ambientPlayer.dispose();
    await _completionPlayer.dispose();
  }

  bool get isPlaying => _ambientPlayer.playing;
  double get volume => _ambientPlayer.volume;
}
