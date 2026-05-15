import 'package:sqlite3/sqlite3.dart';

import '../../domain/models/game_platform.dart';
import '../../domain/models/platform.dart';

class GamePlatformRepository {
  const GamePlatformRepository(this._sqlite);

  final Database _sqlite;

  void insert(GamePlatformLink link) {
    _sqlite.execute(
      'INSERT OR IGNORE INTO game_platforms(gameId,platformId) VALUES(?,?)',
      [link.gameId, link.platformId],
    );
  }

  void delete(GamePlatformLink link) {
    _sqlite.execute(
      'DELETE FROM game_platforms WHERE gameId=? AND platformId=?',
      [link.gameId, link.platformId],
    );
  }

  List<GamePlatformLink> getAll() {
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
}
