import 'package:chat_app/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final receiverId;
  final imageUrl;
  final receicerName;
  const ChatScreen(
      {Key? key, this.receiverId, this.receicerName, this.imageUrl})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final senderId = FirebaseAuth.instance.currentUser!.uid;
  String? message;
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(children: [
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 22,
            foregroundImage: NetworkImage(widget.imageUrl),
          ),
        ]),
        title: Text(widget.receicerName),
        actions: [
          Icon(Icons.phone),
        ],
      ),
      body: Column(children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('messages')
              .doc(widget.receiverId)
              .collection('chats')
              .orderBy('date')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    final dateTimeStamp = doc['date'].toDate();
                    final formatedDate =
                        DateFormat('HH:mm').format(dateTimeStamp);
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        doc['senderId'] == senderId ? 64.0 : 16.0,
                        4,
                        doc['senderId'] == senderId ? 16.0 : 64.0,
                        4,
                      ),
                      child: Align(
                        alignment: doc['senderId'] == senderId
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: doc['senderId'] == senderId
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                            color: doc['senderId'] == senderId
                                ? mainColor
                                : Colors.grey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(doc['message'],
                                style: TextStyle(color: Colors.white)),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 4.0),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         formatedDate.toString(),
                          //         style: TextStyle(
                          //           fontSize: 8,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ),
                    );
                  }));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                    controller: _messageController,
                    // maxLines: 1,
                    // maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Type Your Message',
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
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (message != null || message!.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(senderId)
                          .collection('messages')
                          .doc(widget.receiverId)
                          .collection('chats')
                          .add({
                        'senderId': senderId,
                        'receiverId': widget.receiverId,
                        'type': 'text',
                        'message': message,
                        'date': DateTime.now(),
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(senderId)
                            .collection('messages')
                            .doc(widget.receiverId)
                            .set({
                          'lst_message': message,
                        });
                      });
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.receiverId)
                          .collection('messages')
                          .doc(senderId)
                          .collection('chats')
                          .add({
                        'senderId': senderId,
                        'receiverId': widget.receiverId,
                        'type': 'text',
                        'message': message,
                        'date': DateTime.now(),
                      }).then((value) => {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.receiverId)
                                    .collection('messages')
                                    .doc(senderId)
                                    .set({
                                  'lst_message': message,
                                })
                              });
                      setState(() {
                        _messageController.clear();
                      });
                    } else {
                      return;
                    }
                  },
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: mainColor,
                    // maximumSize: Size.fromHeight(30.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
