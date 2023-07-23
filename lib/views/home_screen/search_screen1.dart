import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:app_thoitrang/views/category_screen/item_details.dart';
import 'package:app_thoitrang/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen1 extends StatelessWidget {
  final String? title;
  const SearchScreen1({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: Container(
        color: whiteColor,
        child: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No product found".text.makeCentered();
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 330),
                  children: data
                      .mapIndexed((currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_imgs'][0],
                                width: 150,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                              10.heightBox,
                              "${data[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${data[index]['p_price']}"
                                  .numVND
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .size(16)
                                  .make()
                            ],
                          )
                              .box
                              .shadow
                              .white
                              .margin(const EdgeInsets.symmetric(horizontal: 4))
                              .rounded
                              .padding(const EdgeInsets.all(8))
                              .make()
                              .onTap(() {
                            // controller.getSubCategories(
                            //     categoriesList[index]);
                            Get.to(() => ItemDetails(
                                title: "${data[index]['p_name']}",
                                data: data[index]));
                          }))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
