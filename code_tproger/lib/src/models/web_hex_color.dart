import 'package:flutter/material.dart';

class WebHexColor extends Color {
  WebHexColor(String webHexColor): super(_parseWebHexColor(webHexColor));

  static int _parseWebHexColor(String webHexColor) {
    webHexColor = webHexColor
      .replaceFirst('#', '')
      .toLowerCase();
    
    if (webHexColor.length == 8) {
      return _parseWebHexColor8(webHexColor);
    } else if (webHexColor.length == 6) {
      return _parseWebHexColor6(webHexColor);
    } else if (webHexColor.length == 4) {
      return _parseWebHexColor4(webHexColor);
    } else if (webHexColor.length == 3) {
      return _parseWebHexColor3(webHexColor);
    } else {
      throw UnimplementedError('Not supported web hex color with length="${webHexColor.length}"');
    }
  }

  static int _parseWebHexColor8(String webHexColor) {
    final rgb = webHexColor.substring(0, 6);
    final alpha = webHexColor.substring(6, 8);

    return _toInt(rgb, alpha);
  }

  static int _parseWebHexColor6(String webHexColor) => _toInt(webHexColor);

  static int _parseWebHexColor4(String webHexColor) {
    final rgb = webHexColor.substring(0, 3);
    final alpha = webHexColor[webHexColor.length - 1] * 2;

    return _toInt(rgb, alpha);
  }

  static int _parseWebHexColor3(String webHexColor) {
    final r = webHexColor[0] * 2;
    final g = webHexColor[1] * 2;
    final b = webHexColor[2] * 2;
    final rgb = r + g + b;

    return _toInt(rgb);
  }

  static int _toInt(String rgb, [String alpha = 'ff']) =>
    int.parse(alpha + rgb, radix: 16);
}