import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/consts/lists.dart';
import 'package:app_thoitrang/controller/auth_controller.dart';
import 'package:app_thoitrang/controller/profile_controller.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:app_thoitrang/views/auth_screen/login_screen.dart';
import 'package:app_thoitrang/views/profile_screen/components/details_cart.dart';
import 'package:app_thoitrang/views/profile_screen/edit_profile_screen.dart';
import 'package:app_thoitrang/widgets_common/bg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(Scaffold(
      body: StreamBuilder(
        stream: FirestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return SafeArea(
              child: Container(
                child: Column(
                  children: [
                    //edit profile button
                    5.heightBox,
                    const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        )).onTap(() {
                      controller.nameController.text = data['name'];

                      Get.to(() => EditProfileScreen(
                            data: data,
                          ));
                    }),

                    //users details section

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ''
                              ? Image.asset(
                                  imgProfile2,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 70,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              5.heightBox,
                              "${data['email']}".text.white.make(),
                            ],
                          )),
                          OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    await Get.put(AuthController())
                                        .signoutMethod(context);
                                    Get.offAll(() => LoginScreen());
                                  },
                                  child: Text(
                                    "Log out",
                                    style: TextStyle(
                                        fontFamily: semibold,
                                        color: Colors.white),
                                  ))
                              .box
                              .margin(EdgeInsets.symmetric(horizontal: 10))
                              .make()
                        ],
                      ),
                    ),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        detailsCart(
                            width: context.screenWidth / 3.2,
                            count: data['cart_count'],
                            title: "in your cart"),
                        detailsCart(
                            width: context.screenWidth / 3.2,
                            count: data['wishlist_count'],
                            title: "in your wishlist"),
                        detailsCart(
                            width: context.screenWidth / 3.2,
                            count: data['order_count'],
                            title: "in your order")
                      ],
                    ),

                    //buttons section
                    ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  leading: Image.asset(
                                    profileButtonsIcon[index],
                                    width: 22,
                                  ),
                                  title: profileButtonsList[index]
                                      .text
                                      .fontFamily(semibold)
                                      .make());
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: profileButtonsList.length)
                        .box
                        .white
                        .margin(EdgeInsets.all(12))
                        .rounded
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    ));
  }
}
