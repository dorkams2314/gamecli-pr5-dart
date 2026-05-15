import 'package:sqlite3/sqlite3.dart';

import '../../domain/models/portal_user.dart';

class UserRepository {
  const UserRepository(this._sqlite);

  final Database _sqlite;

  void insert(PortalUser user) {
    _sqlite.execute(
      'INSERT OR REPLACE INTO users(id,username,email,registeredAt) VALUES(?,?,?,?)',
      [user.id, user.username, user.email, user.registeredAt.toIso8601String()],
    );
  }

  List<PortalUser> getAll() {
    final rows = _sqlite.select(
      'SELECT id,username,email,registeredAt FROM users',
    );
    return rows.map((row) => PortalUser.fromMap(row)).toList();
  }

  PortalUser? getById(String id) {
    final rows = _sqlite.select(
      'SELECT id,username,email,registeredAt FROM users WHERE id=?',
      [id],
    );
    return rows.isNotEmpty ? PortalUser.fromMap(rows.first) : null;
  }

  void delete(String id) {
    _sqlite.execute('DELETE FROM users WHERE id=?', [id]);
  }
}
