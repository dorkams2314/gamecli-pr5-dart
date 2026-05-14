import 'identity.dart';

class PortalUser implements Identity {
  const PortalUser({
    required this.id,
    required this.username,
    required this.email,
    required this.registeredAt,
  });

  factory PortalUser.fromMap(Map<String, dynamic> map) {
    return PortalUser(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      registeredAt: DateTime.parse(map['registeredAt'] as String),
    );
  }

  @override
  final String id;
  final String username;
  final String email;
  final DateTime registeredAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'username': username,
    'email': email,
    'registeredAt': registeredAt.toIso8601String(),
  };

  @override
  String toString() => '$username <$email>';
}
