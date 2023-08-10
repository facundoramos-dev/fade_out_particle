part of 'extensions.dart';

extension IntExtensions on int {
  Color withOpacity(double opacity) {
    final resultOpacity = (opacity * (this & 0xFF) * 0.7).toInt();
    return Color((this >> 8 & 0x00FFFFFF) | (resultOpacity << 24));
  }

  bool get isTransparent => (this & 0xFF) == 0;
}
