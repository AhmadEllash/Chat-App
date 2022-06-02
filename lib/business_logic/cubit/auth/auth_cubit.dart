import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/respositroy/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());
  var mobileNumber;
  var name;
  var imageUrl;
  File? image;

  signInWithGoogle() async {
    await _authRepository.signInWithGoogle();
    emit(SignInWithGoogleCompleted());
  }

  signInWithMobileNumber(String number) async {
    await _authRepository.signInWithMobileNumber(number);
  }

  verifyNumber(String smsCode) async {
    await _authRepository.verifyNumber(smsCode);
    emit(VerifyNumberCompleted());
  }

  saveUserWithMobileNumber(
      String? name, String? phoneNumber, String? imageUrl) async {
    await _authRepository.saveUserWithMobileNumber(
        name!, phoneNumber!, imageUrl!);
  }
}
// signUpWithGoogle() async {
//   await _authRepository.signUpWithGoogle();
//   emit(SignUpWithGoogleCompleted());
// }
