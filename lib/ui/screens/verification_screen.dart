import 'dart:io';

import 'package:chat_app/business_logic/cubit/auth/auth_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerificationScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? name;
  final File? pickedImage;
  const VerificationScreen(
      {Key? key, this.mobileNumber, this.name, this.pickedImage})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? name;
  // String mobileNumber
  bool timeFinished = false;
  String? mobileNumber;
  File? pickedImage;
  String? imageUrl;
  Future<void> uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
        storage.ref().child('/users/${FirebaseAuth.instance.currentUser!.uid}');
    TaskSnapshot uploadImage = await reference.putFile(widget.pickedImage!);
    String url = await uploadImage.ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  initState() {
    name = widget.name;
    mobileNumber = widget.mobileNumber;
    pickedImage = widget.pickedImage;

    super.initState();
  }

  Widget build(BuildContext context) {
    TextEditingController _verificationController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              //TODO Container of verificationImage.
              Container(
                margin: const EdgeInsets.only(top: 100),
                height: 200,
                child: Image.asset('assets/images/protection.png'),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    controller: _verificationController,
                    appContext: context,
                    onSaved: (value) {},
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      disabledColor: Colors.grey,
                      inactiveColor: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // timeFinished == false
                    //     ? Countdown(
                    //         seconds: 30,
                    //         build: (BuildContext context, double time) =>
                    //             Text(time.toString()),
                    //         interval: const Duration(milliseconds: 100),
                    //         onFinished: () {
                    //           setState(() {
                    //             timeFinished = true;
                    //           });
                    //         },
                    //       )
                    //     :
                    TextButton(
                      onPressed: () {
                        // print('$mobileNumber');
                        BlocProvider.of<AuthCubit>(context)
                            .signInWithMobileNumber(mobileNumber!);
                      },
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    BlocProvider.of<AuthCubit>(context)
                        .verifyNumber(_verificationController.text);
                    if (state is VerifyNumberCompleted) {
                      uploadImage();
                      BlocProvider.of<AuthCubit>(context)
                          .saveUserWithMobileNumber(
                        name,
                        mobileNumber,
                        imageUrl,
                      );

                      Navigator.pushReplacementNamed(context, homeScreen);
                    }
                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff011959),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
