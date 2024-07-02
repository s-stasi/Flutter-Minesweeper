import 'package:hive/hive.dart';

part 'difficulty.g.dart';

@HiveType(typeId: 1)
enum Difficulty {
  @HiveField(0)
  easy,

  @HiveField(1)
  medium,

  @HiveField(2)
  hard
}

extension DifficultyExtension on Difficulty {
  String get description {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      default:
        return '';
    }
  }
}
