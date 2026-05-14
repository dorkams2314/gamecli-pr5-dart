import 'identity.dart';

class Game implements Identity {
  const Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.releaseYear,
    required this.ownerUserId,
  });

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      title: map['title'] as String,
      genre: map['genre'] as String,
      releaseYear: map['releaseYear'] as int,
      ownerUserId: map['ownerUserId'] as String,
    );
  }

  @override
  final String id;
  final String title;
  final String genre;
  final int releaseYear;
  final String ownerUserId;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'genre': genre,
    'releaseYear': releaseYear,
    'ownerUserId': ownerUserId,
  };

  @override
  String toString() => '$title ($genre, $releaseYear)';
}
