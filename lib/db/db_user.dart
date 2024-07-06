class DBUser {
  final String id;
  final String createdAt;
  final String name;
  final String email;

  const DBUser({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.email,
  });

  factory DBUser.fromMap(Map<String, dynamic> map) {
    return DBUser(
      id: map['id'],
      createdAt: map['created_at'],
      name: map['name'],
      email: map['email'],
    );
  }
}
