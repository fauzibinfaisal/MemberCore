import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String name;
  final String email;
  final String city;
  final DateTime joinDate;

  const Member({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
    required this.joinDate,
  });

  @override
  List<Object?> get props => [id, name, email, city, joinDate];
}
