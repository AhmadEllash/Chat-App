import 'package:chat_app/business_logic/cubit/auth/auth_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/ui/screens/sign_up_screen.dart';
import 'package:chat_app/ui/screens/verification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  savePhone() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return ListView(
              children: [
                Container(
                  // margin: const EdgeInsets.only(top: 100),
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage('assets/images/slovic.png')),
                  // ),
                  height: 300,
                  width: double.infinity,
                  child: Image.asset('assets/images/chatty-logo.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
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
                      controller: _numberController,
                      onSaved: (value) {
                        setState(() {
                          _numberController.text = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your mobile Number';
                        }
                      },
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      savePhone();
                      checkMobileNumber(_numberController.text, context);
                      if (savePhone()) {
                        if (checkMobileNumber(
                            _numberController.text, context)) {
                          BlocProvider.of<AuthCubit>(context)
                              .signInWithMobileNumber(_numberController.text);
                          Navigator.pushNamed(context, verificationScreen);
                        }
                      }
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
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                googleSignButton(context),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, signUpScreen);
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
            );
          },
        ),
      ),
    );
  }
}

TextButton googleSignButton(BuildContext context) {
  return TextButton(
      onPressed: () {
        BlocProvider.of<AuthCubit>(context).signInWithGoogle();
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(
          child: Text(
            'Sign In With Google',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ));
}

TextButton mobileNumberSignInButton(
    BuildContext context, String number, Function savePhone) {
  return TextButton(
      onPressed: () {
        if (savePhone()) {
          if (checkMobileNumber(number, context)) {
            BlocProvider.of<AuthCubit>(context).signInWithMobileNumber(number);
            Navigator.pushNamed(context, verificationScreen);
          }
        }
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
            'Login',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ));
}

checkMobileNumber(String number, context) async {
  final checkPhoneNumber = await FirebaseFirestore.instance
      .collection('users')
      .where(
        'mobileNumber',
        isEqualTo: number,
      )
      .get();
  if (checkPhoneNumber.docs.isEmpty) {
    print('mobile dosent exist');
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The phone number does\'t exist , please sign up'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    BlocProvider.of<AuthCubit>(context).signInWithMobileNumber(number);
    BlocProvider.of<AuthCubit>(context).mobileNumber = number;
    Navigator.pushNamed(context, verificationScreen);
  }
}
