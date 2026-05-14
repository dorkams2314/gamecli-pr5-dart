class GamePlatformLink {
  const GamePlatformLink({required this.gameId, required this.platformId});

  factory GamePlatformLink.fromMap(Map<String, dynamic> map) {
    return GamePlatformLink(
      gameId: map['gameId'] as String,
      platformId: map['platformId'] as String,
    );
  }

  final String gameId;
  final String platformId;

  Map<String, dynamic> toMap() => {'gameId': gameId, 'platformId': platformId};
}
