import 'package:hive/hive.dart';

part 'user_details.g.dart';

@HiveType(typeId: 1)
class UserDetails {
  @HiveField(0)
  late String username;

  UserDetails({
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      username: json['username'],
    );
  }
}
