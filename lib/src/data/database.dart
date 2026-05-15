import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../domain/models/game.dart';
import '../domain/models/game_platform.dart';
import '../domain/models/platform.dart';
import '../domain/models/portal_user.dart';
import 'repositories/game_platform_repository.dart';
import 'repositories/game_repository.dart';
import 'repositories/platform_repository.dart';
import 'repositories/user_repository.dart';

class GamePortalDatabase {
  GamePortalDatabase(String filePath) : sqlite = sqlite3.open(filePath) {
    sqlite.execute('PRAGMA foreign_keys = ON');
    _createTables();
    _insertSeedData();
  }

  factory GamePortalDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'game_portal.db');
    return GamePortalDatabase(filePath);
  }

  final Database sqlite;

  late final UserRepository users = UserRepository(sqlite);
  late final GameRepository games = GameRepository(sqlite);
  late final PlatformRepository platforms = PlatformRepository(sqlite);
  late final GamePlatformRepository gamePlatforms = GamePlatformRepository(
    sqlite,
  );

  void _createTables() {
    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        registeredAt TEXT NOT NULL
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS games (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        releaseYear INTEGER NOT NULL,
        ownerUserId TEXT NOT NULL,
        FOREIGN KEY (ownerUserId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS platforms (
        id TEXT PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        manufacturer TEXT NOT NULL
      );
    ''');

    sqlite.execute('''
      CREATE TABLE IF NOT EXISTS game_platforms (
        gameId TEXT NOT NULL,
        platformId TEXT NOT NULL,
        PRIMARY KEY (gameId, platformId),
        FOREIGN KEY (gameId) REFERENCES games(id) ON DELETE CASCADE,
        FOREIGN KEY (platformId) REFERENCES platforms(id) ON DELETE CASCADE
      );
    ''');
  }

  void _insertSeedData() {
    users.insert(
      PortalUser(
        id: 'u1',
        username: 'admin',
        email: 'admin@gameportal.local',
        registeredAt: DateTime.utc(2026, 5, 1),
      ),
    );
    users.insert(
      PortalUser(
        id: 'u2',
        username: 'player_one',
        email: 'player1@gameportal.local',
        registeredAt: DateTime.utc(2026, 5, 2),
      ),
    );

    platforms.insert(
      const GamePlatform(id: 'p1', name: 'PC', manufacturer: 'Open platform'),
    );
    platforms.insert(
      const GamePlatform(id: 'p2', name: 'PlayStation 5', manufacturer: 'Sony'),
    );
    platforms.insert(
      const GamePlatform(
        id: 'p3',
        name: 'Xbox Series X',
        manufacturer: 'Microsoft',
      ),
    );

    games.insert(
      const Game(
        id: 'g1',
        title: 'Cyberpunk 2077',
        genre: 'RPG',
        releaseYear: 2020,
        ownerUserId: 'u1',
      ),
    );
    games.insert(
      const Game(
        id: 'g2',
        title: 'Forza Horizon 5',
        genre: 'Racing',
        releaseYear: 2021,
        ownerUserId: 'u2',
      ),
    );

    gamePlatforms.insert(
      const GamePlatformLink(gameId: 'g1', platformId: 'p1'),
    );
    gamePlatforms.insert(
      const GamePlatformLink(gameId: 'g1', platformId: 'p2'),
    );
    gamePlatforms.insert(
      const GamePlatformLink(gameId: 'g2', platformId: 'p1'),
    );
    gamePlatforms.insert(
      const GamePlatformLink(gameId: 'g2', platformId: 'p3'),
    );
  }

  void close() {
    sqlite.dispose();
  }
}
