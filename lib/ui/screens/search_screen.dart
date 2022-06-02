import 'package:chat_app/business_logic/cubit/user/user_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel>? foundedUsers;
  String? name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 35,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 65,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.grey.shade500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.teal.shade700),
                ),
                suffix: TextButton(
                  onPressed: () {
                    BlocProvider.of<UserCubit>(context).searchUser(name!);
                  },
                  child: Icon(
                    Icons.search,
                    color: mainColor,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(.3),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is GetUserCompletedState) {
              foundedUsers = state.searchedUsers;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(foundedUsers![0].imageUrl!),
                    radius: 20,
                  ),
                  title: Text(
                    foundedUsers![0].name!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.message),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(pageBuilder: (context, animation, _) {
                          return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: ChatScreen(
                              receiverId: foundedUsers![0].id,
                              receicerName: foundedUsers![0].name,
                              imageUrl: foundedUsers![0].imageUrl,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ]),
    );
  }
}
