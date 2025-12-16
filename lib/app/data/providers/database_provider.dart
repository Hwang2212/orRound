import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  static Database? _database;

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'orround.db');

    return await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade, onConfigure: _onConfigure);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Journeys table
    await db.execute('''
      CREATE TABLE journeys (
        id TEXT PRIMARY KEY,
        start_time INTEGER NOT NULL,
        end_time INTEGER,
        total_distance REAL DEFAULT 0,
        average_speed REAL DEFAULT 0,
        weather_condition TEXT,
        temperature REAL,
        title TEXT,
        category TEXT DEFAULT 'other',
        tags TEXT DEFAULT '',
        is_synced INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Location points table
    await db.execute('''
      CREATE TABLE location_points (
        id TEXT PRIMARY KEY,
        journey_id TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        speed REAL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (journey_id) REFERENCES journeys(id) ON DELETE CASCADE
      )
    ''');

    // User profile table
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT,
        email TEXT,
        profile_picture_path TEXT,
        referral_code TEXT UNIQUE NOT NULL,
        referred_by_code TEXT,
        is_synced INTEGER DEFAULT 0,
        server_id TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Referrals table
    await db.execute('''
      CREATE TABLE referrals (
        id TEXT PRIMARY KEY,
        referral_code TEXT NOT NULL,
        used_at INTEGER NOT NULL
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        unlocked_at INTEGER NOT NULL
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_journey_id ON location_points(journey_id)');
    await db.execute('CREATE INDEX idx_timestamp ON location_points(timestamp)');
    await db.execute('CREATE INDEX idx_created_at ON journeys(created_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add title column to journeys table
      await db.execute('ALTER TABLE journeys ADD COLUMN title TEXT');
    }

    if (oldVersion < 3) {
      // Add category and tags columns to journeys table
      await db.execute("ALTER TABLE journeys ADD COLUMN category TEXT DEFAULT 'other'");
      await db.execute("ALTER TABLE journeys ADD COLUMN tags TEXT DEFAULT ''");
    }

    if (oldVersion < 4) {
      // Add achievements table
      await db.execute('''
        CREATE TABLE achievements (
          id TEXT PRIMARY KEY,
          type TEXT NOT NULL,
          unlocked_at INTEGER NOT NULL
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
