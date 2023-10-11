class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  UserModel copyWith(
      {String? id, String? name, String? email, String? password}) =>
      UserModel(
          id: this.id,
          name: this.name,
          email: this.email,
          password: this.password);


  factory UserModel.fromJson(Map<String, Object?> json) => UserModel(
    id: json["id"] as String,
    name: json["name"] as String,
    email: json["email"] as String,
    password: json["password"] as String,
  );

  Map<String, Object?> toJson( ) => <String, Object?>{
    "id": id,
    "name": name,
    "email": email,
    "password": password,
  };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          password == other.password;
}
