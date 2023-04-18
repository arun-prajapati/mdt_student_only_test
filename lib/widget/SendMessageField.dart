import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constants/app_colors.dart';

class SendMessageField extends StatefulWidget {
  int userId;
  int studentId;
  SendMessageField({required this.userId, required this.studentId});

  @override
  State<SendMessageField> createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  var _enteredMessage = '';
  final _messageController = new TextEditingController();

  Future<void> _sendMessage() {
    print(_enteredMessage);
    FocusScope.of(context).unfocus();
    print(_enteredMessage);

    return FirebaseFirestore.instance
        .collection('chats/EdkCO6OCqq6ijIhgey5k/messages')
        .add(
      {
        'text': _enteredMessage.toString(),
        'senderId': widget.userId,
        'receiverId': widget.studentId,
        'createdAt': Timestamp.now(),
      },
    ).then(
      (value) {
        print("success");
        _messageController.clear();

        setState(() {
          _enteredMessage = '';
        });
      },
    ).catchError((error) => print("Failed to send message: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              //cursorHeight: 20.0,
              cursorColor: TestColor,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Send a message...",
                focusColor: Dark,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Dark,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Dark,
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Dark,
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (message) {
                setState(() {
                  _enteredMessage = message;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
            color: Dark,
          )
        ],
      ),
    );
  }
}
