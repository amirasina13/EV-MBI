import '../entity.dart';

// User detail entity

class UserEntity extends Entity<String> {
  final String? email;
  final String? password;
  final String? access;
  final bool? isRemember;
  final String? pushToken;

  const UserEntity({
    required String id,
    this.email,
    this.password,
    this.access,
    this.isRemember,
    this.pushToken,
  }) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'access': access,
      'pushToken': pushToken,
      'isRemember': isRemember,
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    password,
    access,
    isRemember,
    pushToken,
  ];
}
