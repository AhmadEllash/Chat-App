part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class SignInWithGoogleCompleted extends AuthState {}
class SignInWithMobileNumberCompleted extends AuthState {}
class VerifyNumberCompleted extends AuthState {}
