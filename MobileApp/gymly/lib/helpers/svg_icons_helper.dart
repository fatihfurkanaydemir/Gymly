import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconsHelper {
  static SvgPicture fromSvg({
    required String svgPath,
    Color? color,
    double? size,
  }) {
    return SvgPicture.asset(
      svgPath,
      height: size,
      theme: SvgTheme(currentColor: color ?? Colors.black),
      width: size,
      fit: BoxFit.none,
    );
  }
}
