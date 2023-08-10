
part of 'extensions.dart';

extension RandomExtensions on math.Random {
  double getRangeDouble(double min, double max) =>
      min + math.Random().nextDouble() * (max - min);
}
