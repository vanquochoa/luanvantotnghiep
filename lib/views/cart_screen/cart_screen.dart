import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/controller/cart_controller.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:app_thoitrang/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets_common/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping cart".text.color(darkFontGrey).fontFamily(bold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Image.network('${data[index]['img']}'),
                            title:
                                "${data[index]['title']} (x${data[index]['qty']})"
                                    .text
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make(),
                            subtitle: "${data[index]['tprice']}"
                                .numVND
                                .text
                                .color(redColor)
                                .fontFamily(semibold)
                                .make(),
                            trailing: const Icon(
                              Icons.delete,
                              color: redColor,
                            ).onTap(() {
                              FirestoreServices.deleteDocument(data[index].id);
                            }),
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total price: "
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        "${controller.totalP.value}"
                            .numVND
                            .text
                            .fontFamily(semibold)
                            .color(redColor)
                            .make()
                      ],
                    )
                        .box
                        .width(context.screenWidth - 60)
                        .padding(EdgeInsets.all(12))
                        .color(lightGolden)
                        .roundedSM
                        .make(),
                    10.heightBox,
                    SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                          color: redColor,
                          onPress: () {},
                          textColor: whiteColor,
                          title: "Proceed to shipping"),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
