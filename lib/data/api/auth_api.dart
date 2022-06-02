import 'package:chat_app/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/main.dart';

class AuthApi {
  final firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  late UserCredential user;
  // ignore: prefer_typing_uninitialized_variables
  var verificationIdReceived;
  var userStatus = 'the mobileNumber does\'t exist';

  Future signInWithGoogle() async {
    GoogleSignInAccount? pickedUser = await googleSignIn.signIn();
    if (pickedUser == null) {
      return;
    }
    final googleAuth = await pickedUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final user =
        await firestore.collection('users').doc(userCredential.user!.uid).get();
    if (user.exists) {
      navigatorKey.currentState!.pushReplacementNamed(homeScreen);
    } else {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'photoUrl': userCredential.user!.photoURL,
        'date': DateTime.now(),
        //'tokenId': userCredential.user!.getIdToken(),
        'status': 'online',
      });
      navigatorKey.currentState!.pushReplacementNamed(homeScreen);
    }
  }

  Future signInWithMobileNumber(String number) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+2$number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        final UserCredential _authResult =
            await _auth.signInWithCredential(credential);
        print(' mobile number is  ${_authResult.user!.phoneNumber}');
        if (_authResult.user!.phoneNumber!.isEmpty) {
          print('Please Sign Up');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // verificationIdReceived = verificationId;
        // // Auto-resolution timed out...
      },
      codeSent: (String? verificationId, int? resendToken) {
        verificationIdReceived = verificationId;
        print('the verification id is $verificationIdReceived');
      },
    );
  }

  Future verifyMobileNumber(String smsCode) async {
    print('the verification id is $verificationIdReceived');

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdReceived, smsCode: smsCode);
    //UserCredential userCredential =
    await _auth.signInWithCredential(credential);
    //user = userCredential;
  }

  saveUserWithMobileNumber(
      String? name, String? phoneNumber, String? imageUrl) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'tokenId': user.user!.getIdToken(),
      'date': DateTime.now(),
    });
  }
}

  // Future signUpWithGoogle() async {
  //   GoogleSignInAccount? pickedUser = await googleSignIn.signIn();
  //   if (pickedUser == null) {
  //     return;
  //   }
  //   final googleAuth = await pickedUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   UserCredential userCredential =
  //       await _auth.signInWithCredential(credential);

  //   final user =
  //       await firestore.collection('users').doc(userCredential.user!.uid).get();
  //   if (user.exists) {
  //     navigatorKey.currentState!.pushReplacementNamed(homeScreen);
  //   } else if (!user.exists) {
  //     await firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'uid': userCredential.user!.uid,
  //       'email': userCredential.user!.email,
  //       'name': userCredential.user!.displayName,
  //       'photoUrl': userCredential.user!.photoURL,
  //       'date': DateTime.now(),
  //       'tokenId': userCredential.user!.getIdToken(),
  //       'status': 'online',
  //     });
  //   }
  // }

