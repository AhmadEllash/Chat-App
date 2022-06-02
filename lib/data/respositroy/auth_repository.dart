import 'package:chat_app/data/api/auth_api.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final AuthApi _authApi;
  AuthRepository(this._authApi);

  signInWithGoogle() async {
    await _authApi.signInWithGoogle();
  }

  signInWithMobileNumber(String number) async {
    await _authApi.signInWithMobileNumber(number);
  }

  verifyNumber(String smsCode) async {
    await _authApi.verifyMobileNumber(smsCode);
  }

  saveUserWithMobileNumber(
      String? name, String? phoneNumber, String? imageUrl) async {
    await _authApi.saveUserWithMobileNumber(name, phoneNumber, imageUrl);
  }

  // signUpWithGoogle() async {
  //   return await _authApi.signUpWithGoogle();
  // }
}
