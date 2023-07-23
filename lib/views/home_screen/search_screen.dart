import 'dart:convert';

import 'package:app_thoitrang/consts/colors.dart';
import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/services/firestore_service.dart';
import 'package:app_thoitrang/widgets_common/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) => StreamBuilder<QuerySnapshot>(
      stream: FirestoreServices.allProducts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return loadingIndicator();
        } else if (snapshot.data!.docs.isEmpty) {
          return "No products".text.make();
        } else {
          var data = snapshot.data!.docs;

          List matchQuery = [];

          var searchDataproduct = data
              .where((element) => element['p_name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();

          // var search = data[0]['p_name'];
          // print(search);
          // print(searchDataproduct);

          // for (var item in searchDataproduct) {
          //   matchQuery.add(item as Product);
          return Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: ["${data[index]['p_name']}".text.make()],
                  );
                }),
          );
        }
      });

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
