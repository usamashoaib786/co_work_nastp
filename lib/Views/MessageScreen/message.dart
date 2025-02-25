import 'package:co_work_nastp/Helpers/app_theme.dart';
import 'package:co_work_nastp/Helpers/custom_appbar.dart';
import 'package:co_work_nastp/Helpers/utils.dart';
import 'package:co_work_nastp/Views/MessageScreen/person_chat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        txt: "Admin Support",
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              push(context, PersonChat());
            },
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppTheme.txtColor),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    "assets/images/user.png",
                    color: AppTheme.white,
                  ),
                ),
              ),
              title: Text(
                "Admin",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Perfect! Will check it 🔥",
                style: TextStyle(color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "09:34 PM",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  // if (chat["unread"] > 0)
                  //   Container(
                  //     margin: const EdgeInsets.only(top: 5),
                  //     padding: const EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //       color: Colors.purple,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child:
                  Text(
                    0.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
