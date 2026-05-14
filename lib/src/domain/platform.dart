import 'identity.dart';

class GamePlatform implements Identity {
  const GamePlatform({
    required this.id,
    required this.name,
    required this.manufacturer,
  });

  factory GamePlatform.fromMap(Map<String, dynamic> map) {
    return GamePlatform(
      id: map['id'] as String,
      name: map['name'] as String,
      manufacturer: map['manufacturer'] as String,
    );
  }

  @override
  final String id;
  final String name;
  final String manufacturer;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'manufacturer': manufacturer,
  };

  @override
  String toString() => '$name by $manufacturer';
}
