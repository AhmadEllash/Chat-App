import 'package:chat_app/data/api/user_api.dart';
import 'package:chat_app/data/models/user_model.dart';

class UserRepository {
  final UserApi _userApi;
  UserRepository(this._userApi);

  Future<List<UserModel>> searchUser(String name) async {
    List searchedUser = await _userApi.searchUser(name);
    return searchedUser.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<List<UserModel>> getUserById(String uid) async {
    List friend = await _userApi.getUserById(uid);
    return friend.map((user) => UserModel.fromJson(user)).toList();
  }
}
