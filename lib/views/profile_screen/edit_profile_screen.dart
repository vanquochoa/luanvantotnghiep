import 'dart:io';
import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/controller/profile_controller.dart';
import 'package:app_thoitrang/widgets_common/bg_widget.dart';
import 'package:app_thoitrang/widgets_common/custom_textfield.dart';
import 'package:app_thoitrang/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //nếu data url image và controller path nó rỗng
            data['imageUrl'] == '' && controller.profileImagePath.isEmpty
                ? Image.asset(
                    imgProfile2,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                //nếu data không rỗng nhưng controllwr path rỗng
                : data['imageUrl'] != '' && controller.profileImagePath.isEmpty
                    ? Image.network(
                        data['imageUrl'],
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    //nếu cả controller path rỗng nhưng data url kh rỗng
                    : Image.file(
                        File(controller.profileImagePath.value),
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ourButton(
                color: redColor,
                onPress: () {
                  controller.changeImage(context);
                },
                textColor: whiteColor,
                title: "Change"),
            const Divider(),
            20.heightBox,
            customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false),
            10.heightBox,
            customTextField(
                controller: controller.oldpassController,
                hint: passwordHint,
                title: oldpass,
                isPass: true),
            10.heightBox,
            customTextField(
                controller: controller.newpassController,
                hint: passwordHint,
                title: newpass,
                isPass: true),
            20.heightBox,
            controller.isLoading.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                : SizedBox(
                    width: context.screenWidth,
                    child: ourButton(
                        color: redColor,
                        onPress: () async {
                          controller.isLoading(true);
                          //nếu chưa chọn image
                          if (controller.profileImagePath.value.isNotEmpty) {
                            await controller.uploadProfileImage();
                          } else {
                            controller.profileImageLink = data['imageUrl'];
                          }
                          //nếu mk cũ trùng với database
                          if (data['password'] ==
                              controller.oldpassController.text) {
                            await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text);
                            await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text);
                            VxToast.show(context, msg: "Update Success");
                          } else {
                            VxToast.show(context, msg: "Wrong old password");
                            controller.isLoading(false);
                          }
                        },
                        textColor: whiteColor,
                        title: "Save"),
                  ),
          ],
        )
            .box
            .white
            .shadowSm
            .padding(EdgeInsets.all(16))
            .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
            .rounded
            .make(),
      ),
    ));
  }
}
