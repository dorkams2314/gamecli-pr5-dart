import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../domain/game.dart';
import '../domain/game_platform.dart';
import '../domain/platform.dart';
import '../domain/portal_user.dart';

class GamePortalDatabase {
  GamePortalDatabase(String filePath) : _sqlite = sqlite3.open(filePath) {
    _sqlite.execute('PRAGMA foreign_keys = ON');
    _createTables();
    _insertSeedData();
  }

  factory GamePortalDatabase.inApp() {
    final filePath = p.join(Directory.current.path, 'game_portal.db');
    return GamePortalDatabase(filePath);
  }

  final Database _sqlite;

  void _createTables() {
    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        registeredAt TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS games (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        releaseYear INTEGER NOT NULL,
        ownerUserId TEXT NOT NULL,
        FOREIGN KEY (ownerUserId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    _sqlite.execute('''
      CREATE TABLE IF NOT EXISTS platforms (
        id TEXT PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        manufacturer TEXT NOT NULL
      );
    ''');

    _sqlite.execute('''
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
    insertUser(
      PortalUser(
        id: 'u1',
        username: 'admin',
        email: 'admin@gameportal.local',
        registeredAt: DateTime.utc(2026, 5, 1),
      ),
    );
    insertUser(
      PortalUser(
        id: 'u2',
        username: 'player_one',
        email: 'player1@gameportal.local',
        registeredAt: DateTime.utc(2026, 5, 2),
      ),
    );

    insertPlatform(
      const GamePlatform(id: 'p1', name: 'PC', manufacturer: 'Open platform'),
    );
    insertPlatform(
      const GamePlatform(id: 'p2', name: 'PlayStation 5', manufacturer: 'Sony'),
    );
    insertPlatform(
      const GamePlatform(
        id: 'p3',
        name: 'Xbox Series X',
        manufacturer: 'Microsoft',
      ),
    );

    insertGame(
      const Game(
        id: 'g1',
        title: 'Cyberpunk 2077',
        genre: 'RPG',
        releaseYear: 2020,
        ownerUserId: 'u1',
      ),
    );
    insertGame(
      const Game(
        id: 'g2',
        title: 'Forza Horizon 5',
        genre: 'Racing',
        releaseYear: 2021,
        ownerUserId: 'u2',
      ),
    );

    linkGameToPlatform(const GamePlatformLink(gameId: 'g1', platformId: 'p1'));
    linkGameToPlatform(const GamePlatformLink(gameId: 'g1', platformId: 'p2'));
    linkGameToPlatform(const GamePlatformLink(gameId: 'g2', platformId: 'p1'));
    linkGameToPlatform(const GamePlatformLink(gameId: 'g2', platformId: 'p3'));
  }

  void insertUser(PortalUser user) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO users(id,username,email,registeredAt) VALUES(?,?,?,?)',
      [user.id, user.username, user.email, user.registeredAt.toIso8601String()],
    );
  }

  List<PortalUser> getAllUsers() {
    final rows = _sqlite.select(
      'SELECT id,username,email,registeredAt FROM users',
    );
    return rows.map((row) => PortalUser.fromMap(row)).toList();
  }

  PortalUser? getUserById(String id) {
    final rows = _sqlite.select(
      'SELECT id,username,email,registeredAt FROM users WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? PortalUser.fromMap(rows.first) : null;
  }

  void deleteUser(String id) {
    _sqlite.execute('DELETE FROM users WHERE id=?', [id]);
  }

  void insertGame(Game game) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO games(id,title,genre,releaseYear,ownerUserId) VALUES(?,?,?,?,?)',
      [game.id, game.title, game.genre, game.releaseYear, game.ownerUserId],
    );
  }

  List<Game> getAllGames() {
    final rows = _sqlite.select(
      'SELECT id,title,genre,releaseYear,ownerUserId FROM games',
    );
    return rows.map((row) => Game.fromMap(row)).toList();
  }

  Game? getGameById(String id) {
    final rows = _sqlite.select(
      'SELECT id,title,genre,releaseYear,ownerUserId FROM games WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Game.fromMap(rows.first) : null;
  }

  void deleteGame(String id) {
    _sqlite.execute('DELETE FROM games WHERE id=?', [id]);
  }

  void insertPlatform(GamePlatform platform) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO platforms(id,name,manufacturer) VALUES(?,?,?)',
      [platform.id, platform.name, platform.manufacturer],
    );
  }

  List<GamePlatform> getAllPlatforms() {
    final rows = _sqlite.select('SELECT id,name,manufacturer FROM platforms');
    return rows.map((row) => GamePlatform.fromMap(row)).toList();
  }

  GamePlatform? getPlatformById(String id) {
    final rows = _sqlite.select(
      'SELECT id,name,manufacturer FROM platforms WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? GamePlatform.fromMap(rows.first) : null;
  }

  void deletePlatform(String id) {
    _sqlite.execute('DELETE FROM platforms WHERE id=?', [id]);
  }

  void linkGameToPlatform(GamePlatformLink link) {
    _sqlite.execute(
      'INSERT OR IGNORE INTO game_platforms(gameId,platformId) VALUES(?,?)',
      [link.gameId, link.platformId],
    );
  }

  void unlinkGameFromPlatform(GamePlatformLink link) {
    _sqlite.execute(
      'DELETE FROM game_platforms WHERE gameId=? AND platformId=?',
      [link.gameId, link.platformId],
    );
  }

  List<GamePlatformLink> getAllGamePlatformLinks() {
    final rows = _sqlite.select('SELECT gameId,platformId FROM game_platforms');
    return rows.map((row) => GamePlatformLink.fromMap(row)).toList();
  }

  List<GamePlatform> getPlatformsForGame(String gameId) {
    final rows = _sqlite.select(
      '''
      SELECT p.id,p.name,p.manufacturer
      FROM platforms p
      INNER JOIN game_platforms gp ON gp.platformId = p.id
      WHERE gp.gameId = ?
      ORDER BY p.name
      ''',
      [gameId],
    );
    return rows.map((row) => GamePlatform.fromMap(row)).toList();
  }

  void close() {
    _sqlite.dispose();
  }
}
