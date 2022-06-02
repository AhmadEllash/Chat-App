part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class GetUserCompletedState extends UserState {
  List<UserModel> searchedUsers;
  GetUserCompletedState(this.searchedUsers);
}

class GetUserByIdCompletedState extends UserState {
  List<UserModel> friends;
  GetUserByIdCompletedState(this.friends);
}
