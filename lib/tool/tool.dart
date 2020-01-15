import 'package:flutter/material.dart';

Color defColor = getColor(74, 74, 63);
Color defColor2 = getColor(118, 111, 92);
Color lightColor = getColor(238, 168, 78);
const imgUrl = 'http://wallpapers.claritywallpaper.com/';

Color getColor(r, g, b, {double o = 1}) {
  return Color.fromRGBO(r, g, b, o);
}

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}