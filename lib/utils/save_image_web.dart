// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> saveImage(Uint8List bytes, String name) async {
  final blob = html.Blob([bytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..style.display = 'none'
    ..download = "$name.png";

  html.document.body!.children.add(anchor);
  anchor.click();
  html.document.body!.children.remove(anchor);

  html.Url.revokeObjectUrl(url);
}
