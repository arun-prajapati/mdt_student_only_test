import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constants/app_colors.dart';
import 'messageBubble.dart';

class MessageList extends StatelessWidget {
  int userId;
  int studentId;
  MessageList({required this.userId, required this.studentId});
  Stream<QuerySnapshot> _chats = FirebaseFirestore.instance
      .collection('chats/EdkCO6OCqq6ijIhgey5k/messages')
      .orderBy(
        'createdAt',
        descending: true,
      )
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        final data = chatSnapshot.data?.docs
            .where(
              (element) =>
                  (element['senderId'] == userId ||
                      element['senderId'] == studentId) &&
                  (element['receiverId'] == userId ||
                      element['receiverId'] == studentId),
            )
            .toList();
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Dark),
          );
        }
        return ListView.builder(
          reverse: true,
          itemCount: data!.length,
          itemBuilder: (context, index) {
            final chatData = data[index];

            return Row(
              mainAxisAlignment: chatData['senderId'] == userId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MessageBubble(
                  data: data[index],
                  userId: userId,
                  key: ValueKey("key $index ${data[index]['receiverId']}"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
