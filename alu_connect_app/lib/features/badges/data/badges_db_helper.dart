import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/engagement_badge_model.dart';

/// BadgesDbHelper — SQLite persistence for Proof of Engagement Badges.
///
/// Tables:
///   badges          — one row per student–event pair (the earned badge)
///   event_attendance— lightweight log of who was marked present per event
///
/// Uses singleton pattern so the database is opened only once per app session.
class BadgesDbHelper {
  static final BadgesDbHelper instance = BadgesDbHelper._internal();
  static Database? _db;

  BadgesDbHelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'alu_connect_badges.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Called on fresh install (no existing DB).
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE badges (
        id          TEXT PRIMARY KEY,
        studentId   TEXT NOT NULL,
        studentName TEXT NOT NULL,
        eventId     TEXT NOT NULL,
        eventName   TEXT NOT NULL,
        eventType   TEXT NOT NULL,
        awardedAt   TEXT NOT NULL,
        awardedBy   TEXT NOT NULL,
        isVerified  INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE event_attendance (
        id          TEXT PRIMARY KEY,
        eventId     TEXT NOT NULL,
        studentId   TEXT NOT NULL,
        markedAt    TEXT NOT NULL,
        markedBy    TEXT NOT NULL
      )
    ''');
  }

  /// Called when existing DB is found at an older version.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS event_attendance (
          id          TEXT PRIMARY KEY,
          eventId     TEXT NOT NULL,
          studentId   TEXT NOT NULL,
          markedAt    TEXT NOT NULL,
          markedBy    TEXT NOT NULL
        )
      ''');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Badge CRUD
  // ──────────────────────────────────────────────────────────────────────────

  /// Insert a single badge record.
  Future<void> insertBadge(EngagementBadgeModel badge) async {
    final db = await database;
    await db.insert(
      'badges',
      badge.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all badges for a student, ordered by most recent first.
  Future<List<EngagementBadgeModel>> getBadgesForStudent(
      String studentId) async {
    final db = await database;
    final maps = await db.query(
      'badges',
      where: 'studentId = ?',
      whereArgs: [studentId],
      orderBy: 'awardedAt DESC',
    );
    return maps.map((m) => EngagementBadgeModel.fromMap(m)).toList();
  }

  /// Returns true if this student already has a badge for this event.
  Future<bool> badgeExists(String studentId, String eventId) async {
    final db = await database;
    final result = await db.query(
      'badges',
      where: 'studentId = ? AND eventId = ?',
      whereArgs: [studentId, eventId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Award badges to all marked-present attendees in a single batch.
  /// Skips students who already have a badge for this event (idempotent).
  Future<void> awardBadgesToAttendees({
    required List<String> studentIds,
    required List<String> studentNames,
    required String eventId,
    required String eventName,
    required String eventType,
    required String awardedBy,
  }) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now();

    for (int i = 0; i < studentIds.length; i++) {
      final alreadyExists = await badgeExists(studentIds[i], eventId);
      if (!alreadyExists) {
        final badge = EngagementBadgeModel(
          id: '${studentIds[i]}_$eventId',
          studentId: studentIds[i],
          studentName: studentNames[i],
          eventId: eventId,
          eventName: eventName,
          eventType: eventType,
          awardedAt: now,
          awardedBy: awardedBy,
          isVerified: true,
        );
        batch.insert(
          'badges',
          badge.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // Also log to event_attendance
        batch.insert(
          'event_attendance',
          {
            'id': '${studentIds[i]}_${eventId}_att',
            'eventId': eventId,
            'studentId': studentIds[i],
            'markedAt': now.toIso8601String(),
            'markedBy': awardedBy,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
    await batch.commit(noResult: true);
  }

  /// Returns badge counts grouped by eventType for the stats bar.
  Future<Map<String, int>> getBadgeCountsByType(String studentId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT eventType, COUNT(*) as count
      FROM badges
      WHERE studentId = ?
      GROUP BY eventType
    ''', [studentId]);

    return {
      for (final row in result)
        row['eventType'] as String: row['count'] as int,
    };
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Attendance log queries
  // ──────────────────────────────────────────────────────────────────────────

  /// Returns all student IDs who were marked present at a given event.
  Future<List<String>> getAttendeeIdsForEvent(String eventId) async {
    final db = await database;
    final result = await db.query(
      'event_attendance',
      columns: ['studentId'],
      where: 'eventId = ?',
      whereArgs: [eventId],
    );
    return result.map((r) => r['studentId'] as String).toList();
  }

  /// Closes the database. Call on app teardown if needed.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
