import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constants/app_colors.dart';
import '../responsive/size_config.dart';

class MessageBubble extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;
  final int userId;
  final Key key;
  MessageBubble({
    required this.data,
    required this.userId,
    required this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data["senderId"] == userId ? Colors.grey[300] : Dark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: data["senderId"] == userId
              ? Radius.circular(12)
              : Radius.circular(0),
          bottomRight: data["senderId"] == userId
              ? Radius.circular(0)
              : Radius.circular(12),
        ),
      ),
      width: 200,
      padding: EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 16,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['text'],
            style: TextStyle(
              color: data["senderId"] == userId ? Colors.black : Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 0.5,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${DateFormat('dd-MM-y HH:mm').format(DateTime.parse(data["createdAt"].toDate().toString()))}",
              style: TextStyle(
                color: data["senderId"] == userId ? Colors.black : Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Positioned(
//               right: 0,
//               bottom: -8,
//               child: Text(
//                 "${DateFormat('d-M-y HH:mm').format(DateTime.parse(data["createdAt"].toDate().toString()))}",
//                 style: TextStyle(
//                   color:
//                       data["senderId"] == userId ? Colors.black : Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),