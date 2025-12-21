import 'package:uuid/uuid.dart';
import '../models/journey.dart';
import '../models/location_point.dart';
import '../providers/database_provider.dart';

class JourneyRepository {
  final DatabaseProvider _dbProvider = DatabaseProvider();
  final _uuid = const Uuid();

  Future<String> saveJourney(Journey journey, List<LocationPoint> points) async {
    final db = await _dbProvider.database;

    await db.transaction((txn) async {
      // Save journey
      await txn.insert('journeys', journey.toMap());

      // Save all location points
      for (final point in points) {
        await txn.insert('location_points', point.toMap());
      }
    });

    return journey.id;
  }

  Future<List<Journey>> getRecentJourneys({int limit = 10}) async {
    final db = await _dbProvider.database;
    final maps = await db.query('journeys', orderBy: 'start_time DESC', limit: limit);

    return maps.map((map) => Journey.fromMap(map)).toList();
  }

  Future<Journey?> getJourneyById(String id) async {
    final db = await _dbProvider.database;
    final maps = await db.query('journeys', where: 'id = ?', whereArgs: [id], limit: 1);

    if (maps.isEmpty) return null;
    return Journey.fromMap(maps.first);
  }

  Future<List<LocationPoint>> getLocationPointsForJourney(String journeyId) async {
    final db = await _dbProvider.database;
    final maps = await db.query('location_points', where: 'journey_id = ?', whereArgs: [journeyId], orderBy: 'timestamp ASC');

    return maps.map((map) => LocationPoint.fromMap(map)).toList();
  }

  Future<int> getJourneyCount() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM journeys');
    return (result.first['count'] as int?) ?? 0;
  }

  Future<void> saveLocationPoint(LocationPoint point) async {
    final db = await _dbProvider.database;
    await db.insert('location_points', point.toMap());
  }

  Future<void> saveLocationPoints(List<LocationPoint> points) async {
    final db = await _dbProvider.database;
    final batch = db.batch();

    for (final point in points) {
      batch.insert('location_points', point.toMap());
    }

    await batch.commit(noResult: true);
  }

  /// Updates the title of an existing journey.
  /// Pass null to clear the title.
  Future<void> updateJourneyTitle(String journeyId, String? title) async {
    final db = await _dbProvider.database;

    // Trim whitespace and convert empty strings to null
    final cleanTitle = title?.trim();
    final finalTitle = (cleanTitle == null || cleanTitle.isEmpty) ? null : cleanTitle;

    await db.update('journeys', {'title': finalTitle}, where: 'id = ?', whereArgs: [journeyId]);
  }

  /// Updates the category of an existing journey.
  Future<void> updateJourneyCategory(String journeyId, String category) async {
    final db = await _dbProvider.database;
    await db.update('journeys', {'category': category}, where: 'id = ?', whereArgs: [journeyId]);
  }

  /// Updates the tags of an existing journey.
  Future<void> updateJourneyTags(String journeyId, List<String> tags) async {
    final db = await _dbProvider.database;
    final tagsString = tags.join(',');
    await db.update('journeys', {'tags': tagsString}, where: 'id = ?', whereArgs: [journeyId]);
  }

  String generateJourneyId() => _uuid.v4();
  String generatePointId() => _uuid.v4();

  // Statistics & Aggregate Queries

  /// Gets the total distance traveled within the specified date range
  Future<double> getTotalDistance({DateTime? from, DateTime? to}) async {
    final db = await _dbProvider.database;

    String query = 'SELECT SUM(total_distance) as total FROM journeys';
    List<dynamic> whereArgs = [];

    if (from != null || to != null) {
      query += ' WHERE';
      if (from != null) {
        query += ' start_time >= ?';
        whereArgs.add(from.millisecondsSinceEpoch);
      }
      if (to != null) {
        if (from != null) query += ' AND';
        query += ' start_time <= ?';
        whereArgs.add(to.millisecondsSinceEpoch);
      }
    }

    final result = await db.rawQuery(query, whereArgs.isEmpty ? null : whereArgs);
    final total = result.first['total'];
    return (total as num?)?.toDouble() ?? 0.0;
  }

  /// Gets the total number of journeys within the specified date range
  Future<int> getTotalJourneys({DateTime? from, DateTime? to}) async {
    final db = await _dbProvider.database;

    String query = 'SELECT COUNT(*) as count FROM journeys';
    List<dynamic> whereArgs = [];

    if (from != null || to != null) {
      query += ' WHERE';
      if (from != null) {
        query += ' start_time >= ?';
        whereArgs.add(from.millisecondsSinceEpoch);
      }
      if (to != null) {
        if (from != null) query += ' AND';
        query += ' start_time <= ?';
        whereArgs.add(to.millisecondsSinceEpoch);
      }
    }

    final result = await db.rawQuery(query, whereArgs.isEmpty ? null : whereArgs);
    return (result.first['count'] as int?) ?? 0;
  }

  /// Gets the total duration (in seconds) within the specified date range
  Future<int> getTotalDuration({DateTime? from, DateTime? to}) async {
    final db = await _dbProvider.database;

    String query = 'SELECT SUM(duration) as total FROM journeys';
    List<dynamic> whereArgs = [];

    if (from != null || to != null) {
      query += ' WHERE';
      if (from != null) {
        query += ' start_time >= ?';
        whereArgs.add(from.millisecondsSinceEpoch);
      }
      if (to != null) {
        if (from != null) query += ' AND';
        query += ' start_time <= ?';
        whereArgs.add(to.millisecondsSinceEpoch);
      }
    }

    final result = await db.rawQuery(query, whereArgs.isEmpty ? null : whereArgs);
    final total = result.first['total'];
    return (total as int?) ?? 0;
  }

  /// Gets the longest journey by distance
  Future<Journey?> getLongestJourney() async {
    final db = await _dbProvider.database;
    final maps = await db.query('journeys', orderBy: 'total_distance DESC', limit: 1);

    if (maps.isEmpty) return null;
    return Journey.fromMap(maps.first);
  }

  /// Gets the fastest journey by average speed
  Future<Journey?> getFastestJourney() async {
    final db = await _dbProvider.database;
    final maps = await db.query('journeys', orderBy: 'average_speed DESC', limit: 1);

    if (maps.isEmpty) return null;
    return Journey.fromMap(maps.first);
  }

  /// Gets daily distances for the last N days for chart display
  Future<Map<DateTime, double>> getDailyDistances(int days) async {
    final db = await _dbProvider.database;
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
    final startMillis = startDate.millisecondsSinceEpoch;

    final result = await db.rawQuery(
      '''
      SELECT 
        DATE(start_time / 1000, 'unixepoch') as date,
        SUM(total_distance) as distance
      FROM journeys
      WHERE start_time >= ?
      GROUP BY date
      ORDER BY date ASC
    ''',
      [startMillis],
    );

    final Map<DateTime, double> dailyDistances = {};

    for (final row in result) {
      final dateString = row['date'] as String;
      final parts = dateString.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      final distance = (row['distance'] as num?)?.toDouble() ?? 0.0;
      dailyDistances[date] = distance;
    }

    return dailyDistances;
  }
}
