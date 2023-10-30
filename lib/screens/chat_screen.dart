import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat/constants.dart';
import 'package:group_chat/screens/welcome_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;
final currentUser = loggedInUser!.email;
DateTime timeNow = DateTime.now();

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  bool isWaiting = false;
  String? messageText;
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    isWaiting = true;
    try {
      loggedInUser = _auth.currentUser!;
      isWaiting = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                });
                
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration.copyWith(
                          hintText: isWaiting
                              ? "Getting data..."
                              : "${loggedInUser!.email}"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (messageText!.isEmpty) {
                        SnackBar(
                          content: Text("Write something you idiot"),
                        );
                      }
                      _firestore.collection('messages').add({
                        "text": messageText,
                        "sender": loggedInUser!.email,
                        "timestamp": FieldValue.serverTimestamp(),
                      });
                      messageController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Colors.lightBlueAccent),
          );
        }
        final messages = snapshot.data!.docs;
        for (var message in messages) {
          final messageText = message['text'];
          final sender = message['sender'];
          final messageWidget = MessageBubble(
            sender: sender,
            text: messageText,
            isMe: sender == currentUser,
          );
          messageBubbles.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            children: messageBubbles,
            reverse: true,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({required this.text, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: isMe
                    ? TextStyle(fontSize: 19, color: Colors.white)
                    : TextStyle(fontSize: 19, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
