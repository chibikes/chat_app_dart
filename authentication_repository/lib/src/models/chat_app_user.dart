import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}

class User extends Equatable {
  /// {@macro user}
  const User({
    // required this.email,
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.age,
    this.country,
    this.email,
    this.photo,
  });

  // final String email;
  final String? id;
  final String? name, firstName, lastName;
  final String? age;
  final String? country;
  final String? photo;
  final String? email;

  static const empty =
  User(id: '', name: null, photo: ''); // photo should be null

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'country': country,
      'photo': photo,
      'email': email,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? age,
    String? country,
    String? photo,
    String? email,
    }
      ) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      country: country ?? this.country,
      photo: photo ?? this.photo,
      email: email ?? this.email,
    );
  }

  static User fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      name: data['name'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      age: data['age'],
      country: data['country'],
      photo: data['photo'],
    );
  }

  @override
  List<Object?> get props => [id, name, photo, country, age, email, firstName, lastName];


}



