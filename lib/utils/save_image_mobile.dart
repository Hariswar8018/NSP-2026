import 'dart:typed_data';
import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';

Future<void> saveImage(Uint8List bytes, String name) async {
  await ImageGallerySaver.saveImage(
    bytes,
    quality: 100,
    name: name,
  );
}
