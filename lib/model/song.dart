import 'dart:typed_data';

class Song {
  final String songName;
  final String artistName;
  final String? albumArtImagePath;
  final String audioPath;
  final Uint8List? albumArt;
  final bool isAsset;

  Song({
    required this.songName,
    required this.artistName,
    this.albumArtImagePath,
    this.albumArt,
    required this.audioPath,
    this.isAsset = true,
  });
}
