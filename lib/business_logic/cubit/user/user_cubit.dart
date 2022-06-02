import 'package:bloc/bloc.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/respositroy/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  List<UserModel> searcedUser = [];
  List<UserModel> friends = [];
  UserCubit(this._userRepository) : super(UserInitial());

  List<UserModel> searchUser(String name) {
    _userRepository.searchUser(name).then((user) {
      emit(GetUserCompletedState(user));
      this.searcedUser = user;
    });
    return searcedUser;
  }

  List<UserModel> getUserById(String uid) {
    _userRepository.getUserById(uid).then((friend) {
      friends.add(friend.first);
      emit(GetUserByIdCompletedState(friends));
    });
    return friends;
  }
}
