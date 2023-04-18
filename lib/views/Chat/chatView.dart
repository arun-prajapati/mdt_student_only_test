import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../Constants/app_colors.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../responsive/size_config.dart';
import '../../widget/MessageList.dart';
import '../../widget/SendMessageField.dart';

class ChatView extends StatefulWidget {
  int userId;
  int studentId;
  ChatView({required this.userId, required this.studentId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.studentId}  ${widget.userId}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: true,
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Dark, Light],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.phone,
        //     ),
        //   ),
        // ],
      ),
      body: Container(
        height: Responsive.height(100, context),
        color: Light,
        child: Container(
          //margin: EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
          child: Container(
            //height: 800,
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 3,
              bottom: SizeConfig.blockSizeVertical * 2,
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3,
            ),
            //color: Colors.black12,
            child: Column(
              children: [
                Expanded(
                  child: MessageList(
                    studentId: widget.studentId,
                    userId: widget.userId,
                  ),
                ),
                SendMessageField(
                  studentId: widget.studentId,
                  userId: widget.userId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
