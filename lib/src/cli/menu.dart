import 'dart:convert';
import 'dart:io';

import '../data/game_portal_database.dart';
import '../domain/game.dart';
import '../domain/game_platform.dart';
import '../domain/platform.dart';
import '../domain/portal_user.dart';

void runMenu(GamePortalDatabase db) {
  while (true) {
    stdout.writeln('''
собственно - игровой портал
1 - глянуть пользователей
2 - добавить пользователя
3 - удалить пользователя по id
4 - глянуть игры
5 - добавить игру
6 - удалить игру по id
7 - глянуть платформы
8 - добавить платформу
9 - удалить платформу по id
10 - привязать игру к платформе
11 - убрать привязку игры к платформе
12 - показать все таблицы
0 - выйти
выбирай пункт:''');

    final choice = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    switch (choice) {
      case '1':
        _printUsers(db);
        break;
      case '2':
        _addUser(db);
        break;
      case '3':
        _deleteUser(db);
        break;
      case '4':
        _printGames(db);
        break;
      case '5':
        _addGame(db);
        break;
      case '6':
        _deleteGame(db);
        break;
      case '7':
        _printPlatforms(db);
        break;
      case '8':
        _addPlatform(db);
        break;
      case '9':
        _deletePlatform(db);
        break;
      case '10':
        _linkGameToPlatform(db);
        break;
      case '11':
        _unlinkGameFromPlatform(db);
        break;
      case '12':
        _printAllFromDb(db);
        break;
      case '0':
        stdout.writeln('пока, всё сохранилось');
        return;
      default:
        stdout.writeln('такой команды нет, попробуй ещё раз');
    }
    stdout.writeln();
  }
}

void _printUsers(GamePortalDatabase db) {
  final users = db.getAllUsers();
  if (users.isEmpty) {
    stdout.writeln('пользователей пока нет');
    return;
  }
  for (final user in users) {
    stdout.writeln(
      'id: ${user.id} | ${user.username} | ${user.email} | ${user.registeredAt.toLocal()}',
    );
  }
}

void _printGames(GamePortalDatabase db) {
  final games = db.getAllGames();
  if (games.isEmpty) {
    stdout.writeln('игр пока нет');
    return;
  }
  for (final game in games) {
    final platforms = db
        .getPlatformsForGame(game.id)
        .map((p) => p.name)
        .join(', ');
    stdout.writeln(
      'id: ${game.id} | ${game.title} | жанр: ${game.genre} | год: ${game.releaseYear} | владелец: ${game.ownerUserId} | платформы: $platforms',
    );
  }
}

void _printPlatforms(GamePortalDatabase db) {
  final platforms = db.getAllPlatforms();
  if (platforms.isEmpty) {
    stdout.writeln('платформ пока нет');
    return;
  }
  for (final platform in platforms) {
    stdout.writeln(
      'id: ${platform.id} | ${platform.name} | ${platform.manufacturer}',
    );
  }
}

void _printLinks(GamePortalDatabase db) {
  final links = db.getAllGamePlatformLinks();
  if (links.isEmpty) {
    stdout.writeln('привязок игр к платформам пока нет');
    return;
  }
  for (final link in links) {
    stdout.writeln('игра: ${link.gameId} | платформа: ${link.platformId}');
  }
}

void _printAllFromDb(GamePortalDatabase db) {
  stdout.writeln('пользователи');
  _printUsers(db);
  stdout.writeln('игры');
  _printGames(db);
  stdout.writeln('платформы');
  _printPlatforms(db);
  stdout.writeln('связи игр и платформ');
  _printLinks(db);
}

void _addUser(GamePortalDatabase db) {
  final id = _read('id пользователя: ');
  final username = _read('никнейм: ');
  final email = _read('email: ');
  final registeredAt = DateTime.now().toUtc();

  db.insertUser(
    PortalUser(
      id: id,
      username: username,
      email: email,
      registeredAt: registeredAt,
    ),
  );
  stdout.writeln('пользователь добавлен');
}

void _deleteUser(GamePortalDatabase db) {
  final id = _read('id пользователя для удаления: ');
  db.deleteUser(id);
  stdout.writeln('готово');
}

void _addGame(GamePortalDatabase db) {
  stdout.writeln('вот доступные пользователи:');
  _printUsers(db);

  final id = _read('id игры: ');
  final title = _read('название: ');
  final genre = _read('жанр: ');
  final releaseYear = int.parse(_read('год выхода: '));
  final ownerUserId = _read('id владельца: ');

  db.insertGame(
    Game(
      id: id,
      title: title,
      genre: genre,
      releaseYear: releaseYear,
      ownerUserId: ownerUserId,
    ),
  );
  stdout.writeln('игра добавлена');
}

void _deleteGame(GamePortalDatabase db) {
  final id = _read('id игры для удаления: ');
  db.deleteGame(id);
  stdout.writeln('готово');
}

void _addPlatform(GamePortalDatabase db) {
  final id = _read('id платформы: ');
  final name = _read('название: ');
  final manufacturer = _read('производитель: ');

  db.insertPlatform(
    GamePlatform(id: id, name: name, manufacturer: manufacturer),
  );
  stdout.writeln('платформа добавлена');
}

void _deletePlatform(GamePortalDatabase db) {
  final id = _read('id платформы для удаления: ');
  db.deletePlatform(id);
  stdout.writeln('готово');
}

void _linkGameToPlatform(GamePortalDatabase db) {
  stdout.writeln('вот доступные игры:');
  _printGames(db);
  stdout.writeln('вот доступные платформы:');
  _printPlatforms(db);

  db.linkGameToPlatform(
    GamePlatformLink(
      gameId: _read('id игры: '),
      platformId: _read('id платформы: '),
    ),
  );
  stdout.writeln('привязка добавлена');
}

void _unlinkGameFromPlatform(GamePortalDatabase db) {
  db.unlinkGameFromPlatform(
    GamePlatformLink(
      gameId: _read('id игры: '),
      platformId: _read('id платформы: '),
    ),
  );
  stdout.writeln('привязка удалена');
}

String _read(String label) {
  stdout.write(label);
  return stdin.readLineSync(encoding: utf8)?.trim() ?? '';
}
