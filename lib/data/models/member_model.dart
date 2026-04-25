import '../../domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.name,
    required super.email,
    required super.city,
    required super.joinDate,
    required super.membershipStatus,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      membershipStatus: json['membershipStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'joinDate': joinDate.toIso8601String(),
      'membershipStatus': membershipStatus,
    };
  }
}
