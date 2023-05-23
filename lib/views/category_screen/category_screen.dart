import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/consts/lists.dart';
import 'package:app_thoitrang/views/category_screen/category_detail.dart';
import 'package:app_thoitrang/widgets_common/bg_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      appBar: AppBar(
        title: categories.text.fontFamily(bold).white.make(),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 200),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(categoriesImage[index],height: 120,width: 200,fit: BoxFit.cover,),
                  10.heightBox,
                  categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make()
                ],

              )
                  .box
                  .white
                  .rounded
                  .clip(Clip.antiAlias)
                  .outerShadowSm
                  .make().onTap(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryDetails(title: categoriesList[index])));
              });
            }),
      ),
    ));
  }
}
