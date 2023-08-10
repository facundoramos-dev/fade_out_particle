part of 'extensions.dart';

extension DoubleExtensions on double {
  double interpolateYAxis(int type) {
    switch (type) {
      case 0:
        return this * this * ((1.7 + 1) * this - 1.7);
      case 1:
        return math.sqrt(1.1 - (this - 1) * (this - 1));
      case 2:
        return math.pow(this, 2.0).toDouble();
      case 3:
        return 1 - math.cos(this * math.pi / 2.0);
      case 4:
        return math.pow(this, 3.0).toDouble();
      default:
        return math.pow(2.0, 10.0 * (this - 1)).toDouble();
    }
  }

  double particleProgress(double width) =>
      math.min(1, this / width.limitedAnimationWidth);

  double get limitedAnimationWidth => math.min(this, 128);
}
