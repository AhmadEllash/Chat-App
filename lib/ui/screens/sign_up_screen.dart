import 'dart:io';

import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/data/api/auth_api.dart';
import 'package:chat_app/data/respositroy/auth_repository.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/ui/screens/verification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../business_logic/cubit/auth/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? myPickedImage;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNmberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  savePhone() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      myPickedImage = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                pickImage();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: myPickedImage != null
                          ? FileImage(File(myPickedImage!.path))
                          : AssetImage('assets/images/profile.png')
                              as ImageProvider,
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'Type Your Name',
                        labelStyle: TextStyle(color: Colors.grey.shade500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.teal.shade700),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.3),
                      ),
                      controller: _nameController,
                      onSaved: (value) {
                        setState(() {
                          _nameController.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Name';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'Type your phone number',
                        labelStyle: TextStyle(color: Colors.grey.shade500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.teal.shade700),
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.3),
                      ),
                      controller: _mobileNmberController,
                      onSaved: (value) {
                        setState(() {
                          _mobileNmberController.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your mobile Number';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      savePhone();
                      checkMobileNumber(_mobileNmberController.text,
                          _nameController.text, context);
                      BlocProvider.of<AuthCubit>(context)
                          .signInWithMobileNumber(_mobileNmberController.text);
                      Navigator.push(
                        context,
                        PageRouteBuilder(pageBuilder: (context, animation, _) {
                          return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: BlocProvider(
                              create: (context) =>
                                  AuthCubit(AuthRepository(AuthApi())),
                              child: VerificationScreen(
                                name: _nameController.text,
                                mobileNumber: _mobileNmberController.text,
                                pickedImage: myPickedImage,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextButton mobileNumberSignUpButton(BuildContext context, String number,
    String name, String imageUrl, Function savePhone) {
  return TextButton(
      onPressed: () {
        savePhone();
        // checkMobileNumber(number, context);
        // if (savePhone()) {
        //   if (checkMobileNumber(number, context)) {
        //     BlocProvider.of<AuthCubit>(context).signInWithMobileNumber(number);
        //     BlocProvider.of<AuthCubit>(context).name = name;
        //     BlocProvider.of<AuthCubit>(context).imageUrl = imageUrl;
        //     Navigator.pushNamed(context, verificationScreen);
        //   }
        // }
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ));
}

checkMobileNumber(String number, String name, context) async {
  final checkPhoneNumber = await FirebaseFirestore.instance
      .collection('users')
      .where(
        'mobileNumber',
        isEqualTo: number,
      )
      .get();
  if (checkPhoneNumber.docs.isNotEmpty) {
    print('mobile dosent exist');
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The phone number is already exist , please sign In'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    // BlocProvider.of<AuthCubit>(context).signInWithMobileNumber(number);
    // BlocProvider.of<AuthCubit>(context).mobileNumber = number;
    // BlocProvider.of<AuthCubit>(context).name = name;
  }
}
