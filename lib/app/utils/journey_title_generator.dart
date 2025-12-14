import 'dart:math';
import 'package:intl/intl.dart';

/// Generates a random display title for journeys without custom titles.
/// This is a pure function with no side effects - it does not save to database.
String generateDisplayTitle(int startTimeMillis) {
  final date = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
  final formatter = DateFormat('MMM dd, yyyy');
  final formattedDate = formatter.format(date);

  // Randomly select between two title patterns
  final random = Random();
  final patterns = ['Journey on $formattedDate', 'Travelling on $formattedDate'];

  return patterns[random.nextInt(patterns.length)];
}
