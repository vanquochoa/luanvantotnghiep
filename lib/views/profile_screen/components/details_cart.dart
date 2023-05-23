import 'package:app_thoitrang/consts/consts.dart';
import 'package:flutter/material.dart';

Widget detailsCart({width, String? count, String? title}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).color(darkFontGrey).make(),
      5.heightBox,
      title!.text.color(darkFontGrey).make()
    ],
  )
      .box
      .white
      .rounded
      .width(width)
      .height(70)
      .padding(const EdgeInsets.all(12))
      .make();
}
