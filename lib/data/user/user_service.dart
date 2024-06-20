import 'package:farmer_geo_locator/data/user/user_details.dart';
import 'package:farmer_geo_locator/data/user/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();

  Future<List<UserDetails>> getUsers() async {
    return _userRepository.getUsers();
  }

  Future<UserDetails> getUser(String username) async {
    return _userRepository.getUser(username);
  }

  Future<void> addUser(UserDetails user) async {
    return _userRepository.addUser(user);
  }

  Future<void> updateUser(UserDetails user) async {
    return _userRepository.updateUser(user);
  }

  Future<void> deleteUser(String username) async {
    return _userRepository.deleteUser(username);
  }
}
