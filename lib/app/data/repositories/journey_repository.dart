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

  String generateJourneyId() => _uuid.v4();
  String generatePointId() => _uuid.v4();
}
