import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

final storage = new FlutterSecureStorage();

Future<String?> getStorageToken() async {
  String? token = await storage.read(key: 'PD_app_access_token');
  print(token);
  return token;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext?.findRenderObject() as RenderBox;

  return renderBox.localToGlobal(Offset.zero);
}

int calculateSecondsDifference(String timestamp) {
  // timestamp.replaceAll(' ', 'T');
  // timestamp += '.000000Z';

  DateTime now = DateTime.now().toUtc();
  // inspect('NOW: ${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}');
  DateTime parsedTime = DateTime.parse(timestamp);
  // inspect('FROM SERVER: ${parsedTime.year}-${parsedTime.month}-${parsedTime.day} ${parsedTime.hour}:${parsedTime.minute}:${parsedTime.second}');

  Duration difference = now.difference(parsedTime);

  // inspect(difference.inSeconds);

  if (difference.isNegative) {
    return 0;
  } else {
    return difference.inSeconds;
  }
}

Future<String> getFilePath(uniqueFileName) async {
  String path = '';

  Directory? dir;
  if (Platform.isAndroid) {
    dir =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))
            ?.first;
  } else {
    dir = await getApplicationDocumentsDirectory();
  }

  path = '${dir!.path}/$uniqueFileName';

  return path;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    print(hexColor);
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 7 || hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
