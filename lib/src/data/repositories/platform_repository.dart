import 'package:sqlite3/sqlite3.dart';

import '../../domain/models/platform.dart';

class PlatformRepository {
  const PlatformRepository(this._sqlite);

  final Database _sqlite;

  void insert(GamePlatform platform) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO platforms(id,name,manufacturer) VALUES(?,?,?)',
      [platform.id, platform.name, platform.manufacturer],
    );
  }

  List<GamePlatform> getAll() {
    final rows = _sqlite.select('SELECT id,name,manufacturer FROM platforms');
    return rows.map((row) => GamePlatform.fromMap(row)).toList();
  }

  GamePlatform? getById(String id) {
    final rows = _sqlite.select(
      'SELECT id,name,manufacturer FROM platforms WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? GamePlatform.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _sqlite.execute('DELETE FROM platforms WHERE id=?', [id]);
  }
}
