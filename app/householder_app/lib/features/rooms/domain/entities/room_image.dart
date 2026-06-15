import 'dart:typed_data';

class RoomImage {
  const RoomImage({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}
