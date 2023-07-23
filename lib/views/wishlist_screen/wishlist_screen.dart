import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!"
                .text
                .color(darkFontGrey)
                .fontFamily(semibold)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                    '${data[index]['p_imgs'][0]}',
                    width: 50,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: "${data[index]['p_name']}"
                      .text
                      .fontFamily(semibold)
                      .size(16)
                      .make(),
                  subtitle: "${data[index]['p_price']}"
                      .numVND
                      .text
                      .color(redColor)
                      .fontFamily(semibold)
                      .make(),
                  trailing: const Icon(
                    Icons.favorite,
                    color: redColor,
                  ).onTap(() {
                    firestore
                        .collection(productCollection)
                        .doc(data[index].id)
                        .set({
                      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                    }, SetOptions(merge: true));
                  }),
                );
              },
            );
          }
        },
      ),
    );
  }
}
