import 'package:flutter/material.dart';
import 'models.dart';

final List<AppTheme> themes = [
  AppTheme(
    id: 'aether',
    name: 'Aether',
    backgroundColor: Color(0xFF0A0A0A),
    accentColor: Color(0xFFD4AF37),
    textColor: Color(0xFFEAEAEA),
  ),
  AppTheme(
    id: 'midnight-blue',
    name: 'Midnight Blue',
    backgroundColor: Color(0xFF0A0A1A),
    accentColor: Color(0xFF4A90E2),
    textColor: Color(0xFFE0E0FF),
  ),
  AppTheme(
    id: 'deep-emerald',
    name: 'Deep Emerald',
    backgroundColor: Color(0xFF0A1A0A),
    accentColor: Color(0xFF50C878),
    textColor: Color(0xFFE0FFE0),
  ),
  AppTheme(
    id: 'royal-purple',
    name: 'Royal Purple',
    backgroundColor: Color(0xFF1A0A1A),
    accentColor: Color(0xFF9B59B6),
    textColor: Color(0xFFFFE0FF),
  ),
];

final List<Sound> sounds = [
  Sound(
    id: 'rain',
    name: 'Soft Rain',
    url: 'https://assets.mixkit.co/active_storage/sfx/2358/2358-preview.mp3',
    category: 'Ambient',
  ),
  Sound(
    id: 'forest',
    name: 'Forest Birds',
    url: 'https://assets.mixkit.co/active_storage/sfx/2437/2437-preview.mp3',
    category: 'Ambient',
  ),
  Sound(
    id: 'waves',
    name: 'Ocean Waves',
    url: 'https://assets.mixkit.co/active_storage/sfx/1188/1188-preview.mp3',
    category: 'Sleep',
  ),
  Sound(
    id: 'white-noise',
    name: 'White Noise',
    url: 'https://assets.mixkit.co/active_storage/sfx/2354/2354-preview.mp3',
    category: 'Sleep',
  ),
  Sound(
    id: 'rainforest',
    name: 'Rainforest',
    url: 'https://assets.mixkit.co/active_storage/sfx/2438/2438-preview.mp3',
    category: 'Sleep',
  ),
  Sound(
    id: 'cosmic-hum',
    name: 'Cosmic Hum',
    url: 'https://assets.mixkit.co/active_storage/sfx/167/167-preview.mp3',
    category: 'Sleep',
  ),
  Sound(
    id: 'chill-pop',
    name: 'Chill Pop',
    url: 'https://assets.mixkit.co/active_storage/sfx/123/123-preview.mp3',
    category: 'Sleep',
  ),
];

const completionSoundUrl =
    'https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3';
