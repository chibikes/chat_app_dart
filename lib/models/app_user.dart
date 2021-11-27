import 'package:equatable/equatable.dart';

class AppUser extends Equatable {

  final String id;
  final List status;

  const AppUser({required this.id, required this.status});


  @override
  // TODO: implement props
  List<Object?> get props => [id, status];

}