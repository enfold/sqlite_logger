import 'dart:math';

import 'package:logging/logging.dart';

class RandomLogGenerator {
  static create() {
    final random = Random();
    final seed = random.nextInt(100);
    final logger = Logger("RandomLogGenerator");
    logger.log(createRandomLvl(seed), 'This is a random message seed: $seed');
  }

  static Level createRandomLvl(seed) {
    if (seed < 10) {
      return Level.ALL;
    } else if (seed < 20) {
      return Level.OFF;
    } else if (seed < 30) {
      return Level.FINEST;
    } else if (seed < 40) {
      return Level.FINER;
    } else if (seed < 50) {
      return Level.FINE;
    } else if (seed < 60) {
      return Level.CONFIG;
    } else if (seed < 70) {
      return Level.INFO;
    } else if (seed < 80) {
      return Level.WARNING;
    } else if (seed < 90) {
      return Level.SEVERE;
    } else {
      return Level.SHOUT;
    }
  }
}
