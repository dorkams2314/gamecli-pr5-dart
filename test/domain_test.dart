import 'package:gamecli/gamecli.dart';
import 'package:test/test.dart';

void main() {
  test('portal user toMap/fromMap keeps data', () {
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

  test('game-platform link toMap/fromMap keeps data', () {
    const link = GamePlatformLink(gameId: 'g1', platformId: 'p1');

    final restored = GamePlatformLink.fromMap(link.toMap());

    expect(restored.gameId, link.gameId);
    expect(restored.platformId, link.platformId);
  });
}
