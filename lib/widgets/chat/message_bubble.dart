import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  // final String username;
  final Key key;
  MessageBubble(this.message, this.isMe, {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 160,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isMe
                  ? Colors.grey[300]
                  : const Color.fromARGB(255, 140, 231, 222)),
          child: Text(message),
          // child: Column(
          //   children: [
          //     Text(
          //       username,
          //       style: const TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     Text(message),
          //   ],
          // ),
        )
      ],
    );
  }
}
