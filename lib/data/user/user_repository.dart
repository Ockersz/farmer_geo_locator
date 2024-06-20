import 'dart:async';

import 'package:hive/hive.dart';

import 'user_details.dart';

class UserRepository {
  static const String _boxName = 'userBox';

  Future<void> init() async {
    await Hive.openBox<UserDetails>(_boxName);
  }

  Future<List<UserDetails>> getUsers() async {
    var box = Hive.box<UserDetails>(_boxName);
    return box.values.toList();
  }

  Future<UserDetails> getUser(String username) async {
    var box = Hive.box<UserDetails>(_boxName);
    return box.values.firstWhere((user) => username == username);
  }

  Future<void> addUser(UserDetails user) async {
    var box = Hive.box<UserDetails>(_boxName);
    await box.put(user.username, user);
  }

  Future<void> updateUser(UserDetails user) async {
    var box = Hive.box<UserDetails>(_boxName);
    await box.put(user.username, user);
  }

  Future<void> deleteUser(String username) async {
    var box = Hive.box<UserDetails>(_boxName);
    await box.delete(username);
  }
}
