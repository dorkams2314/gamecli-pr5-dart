import 'dart:io';

import 'package:gamecli/gamecli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('database creates seed rows', () {
    final tempDir = Directory.systemTemp.createTempSync(
      'game_portal_seed_test_',
    );
    final db = GamePortalDatabase(p.join(tempDir.path, 'test.db'));
    addTearDown(() {
      db.close();
      tempDir.deleteSync(recursive: true);
    });

    expect(db.users.getAll(), hasLength(2));
    expect(db.games.getAll(), hasLength(2));
    expect(db.platforms.getAll(), hasLength(3));
    expect(db.gamePlatforms.getAll(), hasLength(4));
  });

  test('repositories insert game and read platforms for it', () {
    final tempDir = Directory.systemTemp.createTempSync(
      'game_portal_crud_test_',
    );
    final db = GamePortalDatabase(p.join(tempDir.path, 'test.db'));
    addTearDown(() {
      db.close();
      tempDir.deleteSync(recursive: true);
    });

    db.users.insert(
      PortalUser(
        id: 'u3',
        username: 'editor',
        email: 'editor@example.com',
        registeredAt: DateTime.utc(2026, 5, 14),
      ),
    );
    db.games.insert(
      const Game(
        id: 'g3',
        title: 'Hades',
        genre: 'Roguelike',
        releaseYear: 2020,
        ownerUserId: 'u3',
      ),
    );
    db.platforms.insert(
      const GamePlatform(
        id: 'p4',
        name: 'Nintendo Switch',
        manufacturer: 'Nintendo',
      ),
    );
    db.gamePlatforms.insert(
      const GamePlatformLink(gameId: 'g3', platformId: 'p4'),
    );

    final loadedGame = db.games.getById('g3');
    final platforms = db.gamePlatforms.getPlatformsForGame('g3');

    expect(loadedGame, isNotNull);
    expect(loadedGame!.title, 'Hades');
    expect(platforms.single.name, 'Nintendo Switch');
  });

  test('foreign key cascade removes game-platform links', () {
    final tempDir = Directory.systemTemp.createTempSync('game_portal_fk_test_');
    final db = GamePortalDatabase(p.join(tempDir.path, 'test.db'));
    addTearDown(() {
      db.close();
      tempDir.deleteSync(recursive: true);
    });

    db.games.delete('g1');

    expect(
      db.gamePlatforms.getAll().where((link) => link.gameId == 'g1'),
      isEmpty,
    );
  });
}
