import 'package:sqlite3/sqlite3.dart';

import '../../domain/models/game.dart';

class GameRepository {
  const GameRepository(this._sqlite);

  final Database _sqlite;

  void insert(Game game) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO games(id,title,genre,releaseYear,ownerUserId) VALUES(?,?,?,?,?)',
      [game.id, game.title, game.genre, game.releaseYear, game.ownerUserId],
    );
  }

  List<Game> getAll() {
    final rows = _sqlite.select(
      'SELECT id,title,genre,releaseYear,ownerUserId FROM games',
    );
    return rows.map((row) => Game.fromMap(row)).toList();
  }

  Game? getById(String id) {
    final rows = _sqlite.select(
      'SELECT id,title,genre,releaseYear,ownerUserId FROM games WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? Game.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _sqlite.execute('DELETE FROM games WHERE id=?', [id]);
  }
}
