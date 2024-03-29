import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:app_thoitrang/views/chat_screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets_common/loading_indicator.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!"
                .text
                .color(darkFontGrey)
                .fontFamily(semibold)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Get.to(() => ChatScreen(), arguments: [
                                    data[index]['friend_name'],
                                    data[index]['toId']
                                  ]);
                                },
                                leading: const CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: whiteColor,
                                  ),
                                  backgroundColor: redColor,
                                ),
                                title: "${data[index]["friend_name"]}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                subtitle:
                                    "${data[index]["last_msg"]}".text.make(),
                              ),
                            );
                          }))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
