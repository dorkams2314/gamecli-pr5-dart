import 'dart:io';

import 'package:gamecli/gamecli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('PortalUser toMap/fromMap keeps data', () {
    final user = PortalUser(
      id: 'u-test',
      username: 'tester',
      email: 'tester@example.com',
      registeredAt: DateTime.utc(2026, 5, 14),
    );

    final restored = PortalUser.fromMap(user.toMap());

    expect(restored.id, user.id);
    expect(restored.username, user.username);
    expect(restored.email, user.email);
    expect(restored.registeredAt, user.registeredAt);
  });

  test('database creates seed rows', () {
    final tempDir = Directory.systemTemp.createTempSync(
      'game_portal_seed_test_',
    );
    final db = GamePortalDatabase(p.join(tempDir.path, 'test.db'));
    addTearDown(() {
      db.close();
      tempDir.deleteSync(recursive: true);
    });

    expect(db.getAllUsers(), hasLength(2));
    expect(db.getAllGames(), hasLength(2));
    expect(db.getAllPlatforms(), hasLength(3));
    expect(db.getAllGamePlatformLinks(), hasLength(4));
  });

  test('database inserts game and reads platforms for it', () {
    final tempDir = Directory.systemTemp.createTempSync(
      'game_portal_crud_test_',
    );
    final db = GamePortalDatabase(p.join(tempDir.path, 'test.db'));
    addTearDown(() {
      db.close();
      tempDir.deleteSync(recursive: true);
    });

    db.insertUser(
      PortalUser(
        id: 'u3',
        username: 'editor',
        email: 'editor@example.com',
        registeredAt: DateTime.utc(2026, 5, 14),
      ),
    );
    db.insertGame(
      const Game(
        id: 'g3',
        title: 'Hades',
        genre: 'Roguelike',
        releaseYear: 2020,
        ownerUserId: 'u3',
      ),
    );
    db.insertPlatform(
      const GamePlatform(
        id: 'p4',
        name: 'Nintendo Switch',
        manufacturer: 'Nintendo',
      ),
    );
    db.linkGameToPlatform(
      const GamePlatformLink(gameId: 'g3', platformId: 'p4'),
    );

    final loadedGame = db.getGameById('g3');
    final platforms = db.getPlatformsForGame('g3');

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

    db.deleteGame('g1');

    expect(
      db.getAllGamePlatformLinks().where((link) => link.gameId == 'g1'),
      isEmpty,
    );
  });
}
