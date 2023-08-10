part of 'extensions.dart';

extension ByteDataExtensions on ByteData {
  int maybeNonTransparentColor(int i, int j, int width, int space) {
    final offset = (i - space + j * width) * 4;
    if (space == 0 || getInt8(offset + 3) != 0) {
      return getInt32(offset);
    }
    return maybeNonTransparentColor(i, j, width, space - 1);
  }
}
