import 'package:chat_app/business_logic/cubit/user/user_cubit.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/ui/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('messages')
                    .get(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              BlocProvider.of<UserCubit>(context)
                                  .getUserById(snapshot.data!.docs[index].id);
                              DocumentSnapshot docs =
                                  snapshot.data!.docs[index];
                              if (state is GetUserByIdCompletedState) {
                                final friends = state.friends;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation, _) {
                                        return ScaleTransition(
                                          scale: animation,
                                          alignment: Alignment.center,
                                          child: ChatScreen(
                                            receiverId: friends[index].id,
                                            receicerName: friends[index].name,
                                            imageUrl: friends[index].imageUrl,
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/images/chatty-logo.png'),
                                            height: 120,
                                            image: NetworkImage(
                                                friends[index].imageUrl!),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              friends[index].name!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              docs['lst_message'],
                                              style: TextStyle(
                                                overflow: TextOverflow.clip,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }));
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            Navigator.pushNamed(context, searchScreen);
          },
          child: Icon(Icons.search),
        ));
  }
}
